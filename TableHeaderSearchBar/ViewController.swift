//
//  ViewController.swift
//  TableHeaderSearchBar
//
//  Created by Paul Zhang on 7/02/2016.
//  Copyright © 2016 Paul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var searchResults: [SearchResult] = [SearchResult]()
    
    var filteredTableData: [SearchResult] = [SearchResult]()
    
    var searchController: UISearchController!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchResults += [
            SearchResult(name: "One"),
            SearchResult(name: "Two"),
            SearchResult(name: "Three"),
            SearchResult(name: "Four")
        ]
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
//        Hide the search bar after loaded
        tableView.setContentOffset(CGPointMake(0, searchController.searchBar.frame.size.height), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func filterData(forKeyword keyword: String) {
        filteredTableData = searchResults.filter {
            $0.name.lowercaseString.containsString(keyword.lowercaseString)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor.redColor()
        UIView.animateWithDuration(2, animations: { () -> Void in
            cell?.contentView.backgroundColor = UIColor.orangeColor()
            }, completion: nil)
        
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return filteredTableData.count
        } else {
            return searchResults.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath)
        if searchController.active {
            cell.textLabel!.text = filteredTableData[indexPath.row].name
        } else {
            cell.textLabel!.text = searchResults[indexPath.row].name
        }
        return cell
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filterData(forKeyword: searchText)
            tableView.reloadData()
        }
    }
}
