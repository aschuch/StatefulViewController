//
//  ViewController.swift
//  Example
//
//  Created by Alexander Schuch on 30/07/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit
import StatefulViewController

class ViewController: UIViewController, StatefulViewController {
    var dataArray = [String]()
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        // Setup placeholder views
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        let failureView = ErrorView(frame: view.frame)
        failureView.tapGestureRecognizer.addTarget(self, action: #selector(refresh))
        errorView = failureView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupInitialViewState()
        refresh()
    }
    
    func refresh() {
        if (lastState == .Loading) { return }
        
        startLoading {
            print("completaion startLoading -> loadingState: \(self.currentState.rawValue)")
        }
        print("startLoading -> loadingState: \(self.lastState.rawValue)")
        
        // Fake network call
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            // Success
            self.dataArray = ["Merlot", "Sauvignon Blanc", "Blaufränkisch", "Pinot Nior"]
            self.tableView.reloadData()
            self.endLoading(error: nil, completion: {
                print("completion endLoading -> loadingState: \(self.currentState.rawValue)")
            })
            print("endLoading -> loadingState: \(self.lastState.rawValue)")
            
            // Error
            //self.endLoading(error: NSError(domain: "foo", code: -1, userInfo: nil))
            
            // No Content
            //self.endLoading(error: nil)
            
            self.refreshControl.endRefreshing()
        }
    }
    
}


extension ViewController {
    
    func hasContent() -> Bool {
        return dataArray.count > 0
    }
    
    func handleErrorWhenContentAvailable(_ error: Error) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) 
        cell.textLabel?.text = dataArray[(indexPath as NSIndexPath).row]
        return cell
    }
    
}
