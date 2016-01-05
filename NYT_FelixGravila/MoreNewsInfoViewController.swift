//
//  MoreNewsInfoViewController.swift
//  NYT_FelixGravila
//
//  Created by Felix Gravila on 10/12/15.
//  Copyright © 2015 Felix Gravila. All rights reserved.
//

import UIKit

class MoreNewsInfoViewController: UIViewController {
    
    var allJSONData: JSON?
    @IBOutlet weak var TVTitle: UITextView!
    @IBOutlet weak var TVContent: UITextView!
    @IBOutlet weak var TVAuthor: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        TVTitle.text = allJSONData!["title"].stringValue
        TVContent.text = allJSONData!["abstract"].stringValue
        TVAuthor.text = allJSONData!["byline"].stringValue
    }
    
    
    
    
}
