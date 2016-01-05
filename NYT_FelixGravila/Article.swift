//
//  Article.swift
//  NYT_FelixGravila
//
//  Created by Felix Gravila on 10/12/15.
//  Copyright © 2015 Felix Gravila. All rights reserved.
//

import UIKit

class Article {
    var allData: JSON?
    let title: String
    var webURL: String?
    var image: UIImage?
    var section: String?
    
    init(title: String, webURL: String, allData: JSON?){
        self.title = title
        self.webURL = webURL
        self.allData = allData
    }
    
    init(allData: JSON){
        self.section = allData["section"].stringValue
        self.title = allData["title"].stringValue
    }
    
    init(title: String, webURL: String, image: UIImage?, section: String?, allData: JSON?){
        self.title = title
        self.webURL = webURL
        self.image = image
        self.allData = allData
        self.section = section
    }
    
}