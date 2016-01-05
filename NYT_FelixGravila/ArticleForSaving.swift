//
//  ArticleForSaving.swift
//  NYT_FelixGravila
//
//  Created by Felix Gravila on 12/12/15.
//  Copyright © 2015 Felix Gravila. All rights reserved.
//

import UIKit
import CoreData

class ArticleForSaving: NSObject, NSCoding {
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("article")
    
    var title: String
    var webURL: String
    var image: UIImage?
    
    init(data: Article){
        self.title = data.title
        self.webURL = data.webURL!
        self.image = data.image
        
        super.init()
        
    }
    
    init(title: String, webURL: String, image: UIImage?){
        self.title = title
        self.webURL = webURL
        self.image = image
        
        super.init()
        
    }
    
    struct PropertyKey {
        static let titleKey = "titleKey"
        static let webURLKey = "webURLKey"
        static let imageKey = "imageKey"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(webURL, forKey: PropertyKey.webURLKey)
        aCoder.encodeObject(image, forKey: PropertyKey.imageKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let webURL = aDecoder.decodeObjectForKey(PropertyKey.webURLKey) as! String
        let image = aDecoder.decodeObjectForKey(PropertyKey.imageKey) as? UIImage
        
        if title.isEmpty || webURL.isEmpty || image == nil {
            return nil
        }
        self.init(title: title, webURL: webURL, image: image)
    }
    
    
    
}
