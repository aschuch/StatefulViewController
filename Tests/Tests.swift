//
//  StatefulViewControllerTests.swift
//  StatefulViewControllerTests
//
//  Created by Alexander Schuch on 30/07/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit
import XCTest

import Example

class Tests: XCTestCase {

	lazy var stateMachine = ViewStateMachine(view: UIView())
	var errorView: UIView = UIView()
	var loadingView: UIView = UIView()
	var emptyView: UIView = UIView()

    override func setUp() {
        super.setUp()

		errorView = UIView(frame: CGRectMake(0, 0, 320, 480))
		errorView.backgroundColor = UIColor.redColor()

		loadingView = UIView(frame: CGRectMake(0, 0, 320, 480))
		loadingView.backgroundColor = UIColor.blueColor()

		emptyView = UIView(frame: CGRectMake(0, 0, 320, 480))
		emptyView.backgroundColor = UIColor.grayColor()

		stateMachine.addView(errorView, forState: "error")
		stateMachine.addView(loadingView, forState: "loading")
		stateMachine.addView(emptyView, forState: "empty")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStateMachine() {
		stateMachine.transitionToState(.View("error"), animated: true) {
			XCTAssertTrue(self.errorView.superview === self.stateMachine.view, "")
			XCTAssertNil(self.loadingView.superview, "")
			XCTAssertNil(self.emptyView.superview, "")
		}

		stateMachine.transitionToState(.View("loading"), animated: true) {
			XCTAssertNil(self.errorView.superview, "")
			XCTAssertTrue(self.loadingView.superview === self.stateMachine.view, "")
			XCTAssertNil(self.emptyView.superview, "")
		}

		stateMachine.transitionToState(.None, animated: true) {
			XCTAssertNil(self.errorView.superview, "")
			XCTAssertNil(self.loadingView.superview, "")
			XCTAssertNil(self.emptyView.superview, "")
		}

		stateMachine.transitionToState(.View("empty"), animated: true) {
			XCTAssertNil(self.errorView.superview, "")
			XCTAssertNil(self.loadingView.superview, "")
			XCTAssertFalse(self.emptyView.superview === self.stateMachine.view, "")
		}
	}
}
