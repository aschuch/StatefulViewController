//
//  BasicPlaceholderView.swift
//  Example
//
//  Created by Alexander Schuch on 29/08/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit

class BasicPlaceholderView: UIView {

	let centerView: UIView = UIView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupView()
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setupView()
	}
	
	func setupView() {
		backgroundColor = UIColor.whiteColor()
		
		centerView.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.addSubview(centerView)
		
		let views = ["centerView": centerView, "superview": self]
		let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[superview]-(<=1)-[centerView]",
			options: .AlignAllCenterX,
			metrics: nil,
			views: views)
		let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[superview]-(<=1)-[centerView]",
			options: .AlignAllCenterY,
			metrics: nil,
			views: views)
		self.addConstraints(vConstraints)
		self.addConstraints(hConstraints)
	}

}
