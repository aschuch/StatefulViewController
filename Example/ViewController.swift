//
//  ViewController.swift
//  Example
//
//  Created by Alexander Schuch on 30/07/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit
import StatefulViewController

class ViewController: StatefulViewController {
	var dataArray = [String]()
	let refreshControl = UIRefreshControl()
	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup refresh control
		refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: .ValueChanged)
		tableView.addSubview(refreshControl)

		// Setup placeholder views
		loadingView = LoadingView(frame: view.frame)
		emptyView = EmptyView(frame: view.frame)
		let failureView = ErrorView(frame: view.frame)
		failureView.tapGestureRecognizer.addTarget(self, action: Selector("refresh"))
		errorView = failureView
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
        
        refresh()
	}

	func refresh() {
		if (lastState == .Loading) { return }
        
        startLoading(completion: {
            println("completaion startLoading -> loadingState: \(self.currentState.rawValue)")
        })
        println("startLoading -> loadingState: \(self.lastState.rawValue)")
        
        // Fake network call
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
			// Success
			self.dataArray = ["Merlot", "Sauvignon Blanc", "Blaufränkisch", "Pinot Nior"]
			self.tableView.reloadData()
            self.endLoading(error: nil, completion: {
                println("completion endLoading -> loadingState: \(self.currentState.rawValue)")
            })
            println("endLoading -> loadingState: \(self.lastState.rawValue)")

			// Error
			//self.endLoading(error: NSError())

			// No Content
			//self.endLoading(error: nil)
            
            self.refreshControl.endRefreshing()
		}
	}

}

extension ViewController: StatefulViewControllerDelegate {
    func hasContent() -> Bool {
        return count(dataArray) > 0
    }
    
    func handleErrorWhenContentAvailable(error: NSError) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return count(dataArray)
	}

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath) as! UITableViewCell
		cell.textLabel?.text = dataArray[indexPath.row]
		return cell
	}

}
