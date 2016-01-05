//
//  WebViewController.swift
//  NYT_FelixGravila
//
//  Created by Felix Gravila on 10/12/15.
//  Copyright © 2015 Felix Gravila. All rights reserved.
//

import UIKit

class WebViewController: UIViewController{
    var weburl = ""
    
    @IBOutlet weak var webBrowser: UIWebView!

    override func viewDidLoad() {
        webBrowser.loadRequest(NSURLRequest(URL: NSURL(string: weburl)!))
    }
    
    
}
