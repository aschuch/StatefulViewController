//
//  CollectionViewController.swift
//  Example
//
//  Created by Alexander Schuch on 16/05/17.
//  Copyright © 2017 Alexander Schuch. All rights reserved.
//

import Foundation
import StatefulViewController

class CollectionViewController: UICollectionViewController, StatefulViewController {
    fileprivate var dataArray = [String]()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
        collectionView?.alwaysBounceVertical = true

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
            self.collectionView?.reloadData()
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


extension CollectionViewController {

    func hasContent() -> Bool {
        return dataArray.count > 0
    }

    func handleErrorWhenContentAvailable(_ error: Error) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}


extension CollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        return cell
    }
}
