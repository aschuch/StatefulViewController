//
//  ErrorView.swift
//  Example
//
//  Created by Alexander Schuch on 29/08/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit

class ErrorView: BasicPlaceholderView {

	let textLabel = UILabel()
	let detailTextLabel = UILabel()
	let tapGestureRecognizer = UITapGestureRecognizer()
	
	override func setupView() {
		super.setupView()
		
		backgroundColor = UIColor.white
		
		self.addGestureRecognizer(tapGestureRecognizer)
		
		textLabel.text = "Something went wrong."
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		centerView.addSubview(textLabel)
		
		detailTextLabel.text = "Tap to reload"
		let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.footnote)
		detailTextLabel.font = UIFont(descriptor: fontDescriptor, size: 0)
		detailTextLabel.textAlignment = .center
		detailTextLabel.textColor = UIColor.gray
		detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
		centerView.addSubview(detailTextLabel)
		
		let views = ["label": textLabel, "detailLabel": detailTextLabel]
		let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[label]-|", options: .alignAllCenterY, metrics: nil, views: views)
		let hConstraintsDetail = NSLayoutConstraint.constraints(withVisualFormat: "|-[detailLabel]-|", options: .alignAllCenterY, metrics: nil, views: views)
		let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-[detailLabel]-|", options: .alignAllCenterX, metrics: nil, views: views)
		
		centerView.addConstraints(hConstraints)
		centerView.addConstraints(hConstraintsDetail)
		centerView.addConstraints(vConstraints)
	}

}
