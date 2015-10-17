//
//  EmptyView.swift
//  Example
//
//  Created by Alexander Schuch on 29/08/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit

class EmptyView: BasicPlaceholderView {
	
	let label = UILabel()

	override func setupView() {
		super.setupView()
		
		backgroundColor = UIColor.whiteColor()
		
		label.text = "No Content."
		label.translatesAutoresizingMaskIntoConstraints = false
		centerView.addSubview(label)
		
		let views = ["label": label]
		let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-[label]-|", options: .AlignAllCenterY, metrics: nil, views: views)
		let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label]-|", options: .AlignAllCenterX, metrics: nil, views: views)

		centerView.addConstraints(hConstraints)
		centerView.addConstraints(vConstraints)
	}
	
}
