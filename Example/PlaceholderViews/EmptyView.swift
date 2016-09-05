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
		
		backgroundColor = UIColor.white
		
		label.text = "No Content."
		label.translatesAutoresizingMaskIntoConstraints = false
		centerView.addSubview(label)
		
		let views = ["label": label]
		let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[label]-|", options: .alignAllCenterY, metrics: nil, views: views)
		let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: .alignAllCenterX, metrics: nil, views: views)

		centerView.addConstraints(hConstraints)
		centerView.addConstraints(vConstraints)
	}
	
}
