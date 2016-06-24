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
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setupView()
	}
	
	func setupView() {
		backgroundColor = UIColor.whiteColor()
		
		centerView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(centerView)
		
        let vConstraint = NSLayoutConstraint(item: centerView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let hConstraint = NSLayoutConstraint(item: centerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
		self.addConstraint(vConstraint)
		self.addConstraint(hConstraint)
	}

}
