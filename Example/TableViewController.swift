//
//  TableViewController.swift
//  Example
//
//  Created by Alexander Schuch on 16/05/17.
//  Copyright © 2017 Alexander Schuch. All rights reserved.
//

import Foundation
import StatefulViewController

class TableViewController: UITableViewController, StatefulViewController {
    fileprivate var dataArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

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

    @objc func refresh() {
        if (lastState == .loading) { return }

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

            self.refreshControl?.endRefreshing()
        }
    }

}


extension TableViewController {

    func hasContent() -> Bool {
        return dataArray.count > 0
    }

    func handleErrorWhenContentAvailable(_ error: Error) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}


extension TableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
        cell.textLabel?.text = dataArray[(indexPath as NSIndexPath).row]
        return cell
    }

}
