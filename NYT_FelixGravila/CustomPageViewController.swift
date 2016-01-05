//
//  CustomPageViewController.swift
//  NYT_FelixGravila
//
//  Created by Felix Gravila on 10/12/15.
//  Copyright © 2015 Felix Gravila. All rights reserved.
//

import UIKit

class CustomPageViewController: UITableViewController {
    
    var artlist: [ArticleForSaving] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        artlist = loadArticles()!
        self.tableView.reloadData()
    
    }
    
    func loadArticles() -> [ArticleForSaving]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(ArticleForSaving.ArchiveURL.path!) as? [ArticleForSaving]
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FavoritesTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FavoritesTableViewCell
        let art = artlist[indexPath.row]
        cell.favText.text = art.title
        cell.favImage.image = art.image
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artlist.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

}
