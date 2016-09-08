//
//  StatefulViewControllerTests.swift
//  StatefulViewControllerTests
//
//  Created by Alexander Schuch on 12/01/15.
//  Copyright (c) 2015 Alexander Schuch. All rights reserved.
//

import UIKit
import XCTest
import StatefulViewController

class StatefulViewControllerTests: XCTestCase {
    
    lazy var stateMachine = ViewStateMachine(view: UIView())
    var errorView: UIView = UIView()
    var loadingView: UIView = UIView()
    var emptyView: UIView = UIView()
    
    override func setUp() {
        super.setUp()
        
        errorView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        errorView.backgroundColor = UIColor.red
        
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        loadingView.backgroundColor = UIColor.blue
        
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        emptyView.backgroundColor = UIColor.gray
        
        stateMachine.addView(errorView, forState: "error")
        stateMachine.addView(loadingView, forState: "loading")
        stateMachine.addView(emptyView, forState: "empty")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStateMachine() {
        stateMachine.transitionToState(.view("error"), animated: true) {
            XCTAssertTrue(self.errorView.superview === self.stateMachine.view, "")
            XCTAssertNil(self.loadingView.superview, "")
            XCTAssertNil(self.emptyView.superview, "")
        }
        
        stateMachine.transitionToState(.view("loading"), animated: true) {
            XCTAssertNil(self.errorView.superview, "")
            XCTAssertTrue(self.loadingView.superview === self.stateMachine.view, "")
            XCTAssertNil(self.emptyView.superview, "")
        }
        
        stateMachine.transitionToState(.none, animated: true) {
            XCTAssertNil(self.errorView.superview, "")
            XCTAssertNil(self.loadingView.superview, "")
            XCTAssertNil(self.emptyView.superview, "")
        }
        
        stateMachine.transitionToState(.view("empty"), animated: true) {
            XCTAssertNil(self.errorView.superview, "")
            XCTAssertNil(self.loadingView.superview, "")
            XCTAssertFalse(self.emptyView.superview === self.stateMachine.view, "")
        }
    }
    
}
