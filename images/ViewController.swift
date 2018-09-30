//
//  ViewController.swift
//  images
//
//  Created by Koray Birand on 9/30/18.
//  Copyright © 2018 Koray Birand. All rights reserved.
//

import Cocoa

class ViewController: NSViewController,NSCollectionViewDataSource,NSCollectionViewDelegate {
    
    @IBOutlet weak var collectionView: NSScrollView!
    @IBOutlet weak var zoomSlider: NSSlider!
    
    
    
   
    
    @IBAction func zoomImages(_ sender: Any) {
        
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return  filesArray.count
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "photos"), for: indexPath)
        
        guard let pictureItem = item as? photos else { return item }
        
        pictureItem.textField?.textColor = NSColor.black
        
        
        pictureItem.imageView?.image = NSImage(contentsOfFile: filesArray[indexPath.item])
        pictureItem.textField?.stringValue = URL(fileURLWithPath: filesArray[indexPath.item]).lastPathComponent
        return item
        
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

