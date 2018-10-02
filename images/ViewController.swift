//
//  ViewController.swift
//  images
//
//  Created by Koray Birand on 9/30/18.
//  Copyright © 2018 Koray Birand. All rights reserved.
//

import Cocoa

class ViewController: NSViewController,NSCollectionViewDataSource,NSCollectionViewPrefetching,NSCollectionViewDelegate {
    
    @IBOutlet weak var collectionView: NSScrollView!
    @IBOutlet weak var zoomSlider: NSSlider!
    let serialQueue = DispatchQueue(label: "Decode queue")
    var cache = [String:NSImage]()
    
   
    
    @IBAction func zoomImages(_ sender: Any) {
        
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return  filesArray.count
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "photos"), for: indexPath)
        guard let pictureItem = item as? photos else { return item }
        print("index path requested=\(indexPath.description)")

        pictureItem.textField?.textColor = NSColor.black
        let imageViewSize = pictureItem.imageView?.bounds.size
        let scale = CGFloat(1.0) //collectionView.traitCollection.displayScale
        let fileUrl = URL(fileURLWithPath: filesArray[indexPath.item])
        pictureItem.imageView?.image = downsample(imageAt:fileUrl,to: imageViewSize!, scale: scale)
        
        pictureItem.imageView?.image = self.cache["\(indexPath.description)"] ?? NSImage(contentsOfFile: filesArray[indexPath.item])
        pictureItem.textField?.stringValue = fileUrl.lastPathComponent
        return pictureItem
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Asynchronously decode and downsample every image we are about to show
        for indexPath in indexPaths {
            print("index path prefetch=\(indexPath.description)")

            let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "photos"), for: indexPath)
            guard let pictureItem = item as? photos else { return }
            let imageViewSize = pictureItem.imageView?.bounds.size
            let scale = CGFloat(1.0)
            let fileUrl = URL(fileURLWithPath: filesArray[indexPath.item])

            if cache["\(indexPath.description)"] == nil {
                serialQueue.async {
                    let downsampledImage = self.downsample(imageAt: fileUrl, to: imageViewSize!, scale: scale)
                    print("index path downsample=\(indexPath.description) \(downsampledImage?.size)")
                    DispatchQueue.main.async {
                        if let image = downsampledImage {
                            self.cache["\(indexPath.description)"] = image
                        }
                    }
                }
            }
        }
    }
    
    
    // Downsampling large images for display at smaller size
    
    func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> NSImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else { return nil }
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions =
            [kCGImageSourceCreateThumbnailFromImageAlways: true,
             kCGImageSourceShouldCacheImmediately: true,
             kCGImageSourceCreateThumbnailWithTransform: true,
             kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        let downsampledImage =
            CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
        return NSImage(cgImage: downsampledImage, size: pointSize)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

