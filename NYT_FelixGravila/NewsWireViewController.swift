//
//  NewsWireViewController.swift
//  NYT_FelixGravila
//
//  Created by Felix Gravila on 10/12/15.
//  Copyright © 2015 Felix Gravila. All rights reserved.
//

import UIKit

class NewsWireViewController: UITableViewController {
    
    @IBOutlet var newsTableView: UITableView!
    var dataToSend:JSON?
    let baseRequestURL = "http://api.nytimes.com/svc/news/v3/content/all/all/.json?api-key="
    var newsList: [Article] = []
    var sectionList: [String] = []
    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator()
    
        indicator.startAnimating()
        
        getData()
    }
    
    func activityIndicator(){
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    
    //MARK: Data retrieval
    
    func getData(){
        
        let downloadUserDataSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let key = NSUserDefaults.standardUserDefaults().objectForKey("Newswire") as! String
        let myUserDataURL = NSURL(string: baseRequestURL + key)
        
        let userDataSession = NSURLSession(
            configuration: downloadUserDataSessionConfiguration,
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue())
        
        let myDataTask = userDataSession.dataTaskWithURL(myUserDataURL!) { (data, response, error) -> Void in
            if(error == nil){
                let articleDataJSON = JSON(data: data!)
                
                for news in articleDataJSON["results"].array! {
                    let atitle = news["title"].stringValue
                    let awebURL = news["url"].stringValue
                    var img: UIImage?
                    let section = news["section"].stringValue
                    if(news["multimedia"].array != nil){
                        let imageURL = news["multimedia"][0]["url"].stringValue
                        if let url = NSURL(string: imageURL) {
                            if let data = NSData(contentsOfURL: url) {
                                img = UIImage(data: data)
                            }
                        }
                    }
                    
                    
                    self.newsList.append(Article(title: atitle, webURL: awebURL, image: img, section: section, allData: news))
                    if !self.sectionList.contains(section) {
                        self.sectionList.append(section)
                    }
                    
                    self.indicator.stopAnimating()
                    self.indicator.alpha = 0
                    self.newsTableView.reloadData()
                }
            }
        }
        
        myDataTask.resume()
        
    }
    
    

    //MARK: TableView stuff
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "NewsWireTableWiewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsWireTableViewCell
        
        var slist: [Article] = []
        
        
        
        for a in newsList {
            if a.section == sectionList[indexPath.section] {
                slist.append(a)
            }
        }
        
        let nws = slist[indexPath.row]
        
        cell.titleText.text = nws.title
        if nws.image != nil {
            cell.titleImage.image = nws.image
        }
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var c = 0
        for a in newsList {
            if a.section == sectionList[section] {
                c++
            }
        }
        return c
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        newsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var slist: [Article] = [] 
        
        for a in newsList {
            if a.section == sectionList[indexPath.section] {
                slist.append(a)
            }
        }
        
        self.dataToSend = slist[indexPath.row].allData
        
        performSegueWithIdentifier("moreNewsInfo", sender: self)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "moreNewsInfo" {
            if let nic:MoreNewsInfoViewController = segue.destinationViewController as! MoreNewsInfoViewController {
                nic.allJSONData = self.dataToSend
            }
        }
    }

}
