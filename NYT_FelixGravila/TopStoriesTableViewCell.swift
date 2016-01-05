//
//  TopStoriesTableViewCell.swift
//  NYT_FelixGravila
//
//  Created by Felix Gravila on 12/12/15.
//  Copyright © 2015 Felix Gravila. All rights reserved.
//

import UIKit
import CoreData

class TopStoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var savedImage: UIImageView!
    
    var art: Article?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapper = UITapGestureRecognizer(target: self, action: "saveIt")
        tapper.numberOfTapsRequired = 1
        savedImage.addGestureRecognizer(tapper)
    }
    
    func saveIt(){
        savedImage.image = UIImage(named: "filled")
        if(art != nil){
            
//            do {
//                try NSFileManager.defaultManager().removeItemAtPath(ArticleForSaving.ArchiveURL.path!)
//            } catch {
//                print("No file")
//            }
            

            
            let tosave = ArticleForSaving(data: art!)
            var wholeList: [ArticleForSaving] = []
            
            if NSKeyedUnarchiver.unarchiveObjectWithFile(ArticleForSaving.ArchiveURL.path!) != nil {
                let a = NSKeyedUnarchiver.unarchiveObjectWithFile(ArticleForSaving.ArchiveURL.path!) as! [ArticleForSaving]
                for b in a {
                    wholeList.append(b)
                }
            }
            
            var sw = false
            
            for e in wholeList {
                if e.webURL == tosave.webURL {
                    sw = true
                }
            }
            
            if !sw {
                wholeList.append(tosave)
            } else {
                print("already in the database")
            }
            
            
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(wholeList, toFile: ArticleForSaving.ArchiveURL.path!)
            
            if !isSuccessfulSave {
                print("Failed to save meals...")
            }
            
        }
    }
    
}
