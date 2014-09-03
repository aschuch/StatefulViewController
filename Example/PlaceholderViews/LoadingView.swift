//
//  LoadingView.swift
//  Example
//
//  Created by Alexander Schuch on 29/08/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit

class LoadingView: BasicPlaceholderView {

	let label = UILabel()
	
	override func setupView() {
		super.setupView()
		
		backgroundColor = UIColor.whiteColor()
		
		label.text = "Loading..."
		label.setTranslatesAutoresizingMaskIntoConstraints(false)
		centerView.addSubview(label)
		
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
		activityIndicator.startAnimating()
		activityIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
		centerView.addSubview(activityIndicator)
		
		let views = ["label": label, "activity": activityIndicator]
		let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-[activity]-[label]-|", options: nil, metrics: nil, views: views)
		let vConstraintsLabel = NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: nil, metrics: nil, views: views)
		let vConstraintsActivity = NSLayoutConstraint.constraintsWithVisualFormat("V:|[activity]|", options: nil, metrics: nil, views: views)

		centerView.addConstraints(hConstraints)
		centerView.addConstraints(vConstraintsLabel)
		centerView.addConstraints(vConstraintsActivity)
	}

}
