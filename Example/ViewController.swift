//
//  ViewController.swift
//  Example
//
//  Created by Alexander Schuch on 30/07/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit
import StatefulViewController

class ViewController: UITableViewController, StatefulViewController {
    var dataArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        
        // Setup placeholder views
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        let failureView = ErrorView(frame: view.frame)
        failureView.tapGestureRecognizer.addTarget(self, action: #selector(refresh))
        errorView = failureView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupInitialViewState()
        refresh()
    }
    
    func refresh() {
        if (lastState == .Loading) { return }
        
        startLoading(completion: {
            print("completion startLoading -> loadingState: \(self.currentState.rawValue)")
        })
        print("startLoading -> loadingState: \(self.lastState.rawValue)")
        
        // Fake network call
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            // Success
//            self.dataArray = ["Merlot", "Sauvignon Blanc", "Blaufränkisch", "Pinot Nior"]
//            self.tableView.reloadData()
//            self.endLoading(error: nil, completion: {
//                print("completion endLoading -> loadingState: \(self.currentState.rawValue)")
//            })
//            print("endLoading -> loadingState: \(self.lastState.rawValue)")
            
            // Error
//            self.endLoading(error: NSError(domain: "foo", code: -1, userInfo: nil))
            
            // No Content
            self.endLoading(error: nil)
            
            self.refreshControl?.endRefreshing()
        }
    }
    
}


extension ViewController {
    
    func hasContent() -> Bool {
        return dataArray.count > 0
    }
    
    func handleErrorWhenContentAvailable(error: ErrorType) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}


extension ViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath) 
        cell.textLabel?.text = "HELLO!"
//        dataArray[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("CLICKED ROW!")
    }
    
}
