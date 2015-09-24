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
		
		backgroundColor = UIColor.whiteColor()
		
		self.addGestureRecognizer(tapGestureRecognizer)
		
		textLabel.text = "Something went wrong."
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		centerView.addSubview(textLabel)
		
		detailTextLabel.text = "Tap to reload"
		let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleFootnote)
		detailTextLabel.font = UIFont(descriptor: fontDescriptor, size: 0)
		detailTextLabel.textAlignment = .Center
		detailTextLabel.textColor = UIColor.grayColor()
		detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
		centerView.addSubview(detailTextLabel)
		
		let views = ["label": textLabel, "detailLabel": detailTextLabel]
		let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-[label]-|", options: .AlignAllCenterY, metrics: nil, views: views)
		let hConstraintsDetail = NSLayoutConstraint.constraintsWithVisualFormat("|-[detailLabel]-|", options: .AlignAllCenterY, metrics: nil, views: views)
		let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label]-[detailLabel]-|", options: .AlignAllCenterX, metrics: nil, views: views)
		
		centerView.addConstraints(hConstraints)
		centerView.addConstraints(hConstraintsDetail)
		centerView.addConstraints(vConstraints)
	}

}
