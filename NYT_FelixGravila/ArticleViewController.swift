//
//  FirstViewController.swift
//  NYT_FelixGravila
//
//  Created by Felix Gravila on 10/12/15.
//  Copyright © 2015 Felix Gravila. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let baseAPIURL = "http://api.nytimes.com/svc/search/v2/articlesearch.json?q="
    let baseBeforeKeyURL = "&api-key="
    var urlForSegue = ""
    var articleList: [Article] = []
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        articleTableView.delegate = self
        articleTableView.dataSource = self
        activityIndicator.alpha = 0
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        articleList.removeAll()
        searchArticlesByTitle(searchBar.text!)
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        articleTableView.alpha = 0.3
        articleTableView.userInteractionEnabled = false
    }
    
    
    
    func searchArticlesByTitle(searchTerms: String){
        
        //1. NSURLSession Configuration
        let downloadUserDataSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let defaults = NSUserDefaults.standardUserDefaults()
        let key = defaults.objectForKey("ArticleSearch") as! String
        let searchTermsCorrected = searchTerms.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let searchurl = baseAPIURL + searchTermsCorrected + baseBeforeKeyURL + key
        let myUserDataURL = NSURL(string: searchurl)
        
        //2. NSURLSession
        
        let userDataSession = NSURLSession(
            configuration: downloadUserDataSessionConfiguration,
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue())
        
        //3. Create a thread and download data asynchronously
        
        let myDataTask = userDataSession.dataTaskWithURL(myUserDataURL!) { (data, response, error) -> Void in
            if(error == nil){
                let articleDataJSON = JSON(data: data!)
                
                for art in articleDataJSON["response"]["docs"].array! {
                    
                    let atitle = art["headline"]["main"].stringValue
                    let awebURL = art["web_url"].stringValue
                    self.articleList.append(Article(title: atitle, webURL: awebURL, allData: nil))
                    self.articleTableView.reloadData()
                    self.activityIndicator.alpha = 0
                    self.activityIndicator.stopAnimating()
                    self.articleTableView.alpha = 1
                    self.articleTableView.userInteractionEnabled = true
                }
            }
        }
        
        myDataTask.resume()
    }
    
    //MARK: table view stuff
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ArticleTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ArticleTableViewCell
        let art = articleList[indexPath.row]
        cell.titleText.text = art.title
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        articleTableView.deselectRowAtIndexPath(indexPath, animated: true)
        urlForSegue = articleList[indexPath.row].webURL!
        performSegueWithIdentifier("articleWeb", sender: self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "articleWeb" {
            if let webc:WebViewController = segue.destinationViewController as! WebViewController {
                webc.weburl = urlForSegue
            }
        }
    }

}

