//
//  LoadingView.swift
//  Example
//
//  Created by Alexander Schuch on 29/08/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit
import StatefulViewController

class LoadingView: BasicPlaceholderView, StatefulPlaceholderView {

	let label = UILabel()
	
	override func setupView() {
		super.setupView()
		
		backgroundColor = UIColor.red
		
		label.text = "Loading..."
		label.translatesAutoresizingMaskIntoConstraints = false
		centerView.addSubview(label)
		
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		activityIndicator.startAnimating()
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		centerView.addSubview(activityIndicator)
		
		let views = ["label": label, "activity": activityIndicator]
		let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[activity]-[label]-|", options: [], metrics: nil, views: views)
		let vConstraintsLabel = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: views)
		let vConstraintsActivity = NSLayoutConstraint.constraints(withVisualFormat: "V:|[activity]|", options: [], metrics: nil, views: views)

		centerView.addConstraints(hConstraints)
		centerView.addConstraints(vConstraintsLabel)
		centerView.addConstraints(vConstraintsActivity)
	}

    func placeholderViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 100, left: 10, bottom: 200, right: 50)
    }

}
