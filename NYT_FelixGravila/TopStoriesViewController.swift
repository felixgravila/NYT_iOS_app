//
//  TopStoriesViewController.swift
//  NYT_FelixGravila
//
//  Created by Felix Gravila on 10/12/15.
//  Copyright © 2015 Felix Gravila. All rights reserved.
//

import UIKit

class TopStoriesViewController: UITableViewController {
    
    var indicator = UIActivityIndicatorView()
    let baseRequestURL = "http://api.nytimes.com/svc/topstories/v1/home.json?api-key="
    var topStoriesList: [Article] = []
    var sectionList: [String] = []
    
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
        let key = NSUserDefaults.standardUserDefaults().objectForKey("TopStories") as! String
            
            let myUserDataURL = NSURL(string: baseRequestURL + key)
            
            let userDataSession = NSURLSession(
                configuration: downloadUserDataSessionConfiguration,
                delegate: nil,
                delegateQueue: NSOperationQueue.mainQueue())
            
            let myDataTask = userDataSession.dataTaskWithURL(myUserDataURL!) { (data, response, error) -> Void in
                if(error == nil){
                    
                    let articleDataJSON = JSON(data: data!)
                    
                    for story in articleDataJSON["results"].array! {
                        let atitle = story["title"].stringValue
                        let awebURL = story["url"].stringValue
                        var img: UIImage?
                        let section = story["section"].stringValue
                        if(story["multimedia"].array != nil){
                            let imageURL = story["multimedia"][0]["url"].stringValue
                            if let url = NSURL(string: imageURL) {
                                if let data = NSData(contentsOfURL: url) {
                                    img = UIImage(data: data)
                                }
                            }
                        }
                        
                        
                        self.topStoriesList.append(Article(title: atitle, webURL: awebURL, image: img, section: section, allData: story))
                        if !self.sectionList.contains(section) {
                            self.sectionList.append(section)
                        }
                        
                        self.indicator.stopAnimating()
                        self.indicator.alpha = 0
                        self.tableView.reloadData()
                    }
                    
                }
            }
            
            myDataTask.resume()
        
    }
    
    
    
    //MARK: TableView stuff
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TopStoriesTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TopStoriesTableViewCell
        
        var slist: [Article] = []
        
        
        
        for a in topStoriesList {
            if a.section == sectionList[indexPath.section] {
                slist.append(a)
            }
        }
        
        let nws = slist[indexPath.row]
        
        cell.titleText.text = nws.title
        if nws.image != nil {
            cell.titleImage.image = nws.image
        }
        cell.art = nws
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var c = 0
        for a in topStoriesList {
            if a.section == sectionList[section] {
                c++
            }
        }
        return c
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    
}
