//
//  ViewStateMachine.swift
//  StatefulViewController
//
//  Created by Alexander Schuch on 30/07/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit


/// Represents the state of the view state machine
public enum ViewStateMachineState : Equatable {
    case None			// No view shown
    case View(String)	// View with specific key is shown
}

public func == (lhs: ViewStateMachineState, rhs: ViewStateMachineState) -> Bool {
    switch (lhs, rhs) {
    case (.None, .None): return true
    case (.View(let lName), .View(let rName)): return lName == rName
    default: return false
    }
}


///
/// A state machine that manages a set of views.
///
/// There are two possible states:
///		* Show a specific placeholder view, represented by a key
///		* Hide all managed views
///
public class ViewStateMachine {
    private var viewStore: [String: UIView]
    private let queue = dispatch_queue_create("com.aschuch.viewStateMachine.queue", DISPATCH_QUEUE_SERIAL)
    
    /// The view that should act as the superview for any added views
    public let view: UIView
    
    /// The current display state of views
    public private(set) var currentState: ViewStateMachineState = .None
    
    /// The last state that was enqueued
    public private(set) var lastState: ViewStateMachineState = .None
    
    
    // MARK: Init
    
    ///  Designated initializer.
    ///
    /// - parameter view:		The view that should act as the superview for any added views
    /// - parameter states:		A dictionary of states
    ///
    /// - returns:			A view state machine with the given views for states
    ///
    public init(view: UIView, states: [String: UIView]?) {
        self.view = view
        viewStore = states ?? [String: UIView]()
    }
    
    /// - parameter view:		The view that should act as the superview for any added views
    ///
    /// - returns:			A view state machine
    ///
    public convenience init(view: UIView) {
        self.init(view: view, states: nil)
    }
    
    
    // MARK: Add and remove view states
    
    /// - returns: the view for a given state
    public func viewForState(state: String) -> UIView? {
        return viewStore[state]
    }
    
    /// Associates a view for the given state
    public func addView(view: UIView, forState state: String) {
        viewStore[state] = view
    }
    
    ///  Removes the view for the given state
    public func removeViewForState(state: String) {
        viewStore[state] = nil
    }
    
    
    // MARK: Subscripting
    
    public subscript(state: String) -> UIView? {
        get {
            return viewForState(state)
        }
        set(newValue) {
            if let value = newValue {
                addView(value, forState: state)
            } else {
                removeViewForState(state)
            }
        }
    }
    
    
    // MARK: Switch view state
    
    /// Adds and removes views to and from the `view` based on the given state.
    /// Animations are synchronized in order to make sure that there aren't any animation gliches in the UI
    ///
    /// - parameter state:		The state to transition to
    /// - parameter animated:	true if the transition should fade views in and out
    /// - parameter campletion:	called when all animations are finished and the view has been updated
    ///
    public func transitionToState(state: ViewStateMachineState, animated: Bool = true, completion: (() -> ())? = nil) {
        lastState = state
        
        dispatch_async(queue) {
            if state == self.currentState {
                return
            }
            
            // Suspend the queue, it will be resumed in the completion block
            dispatch_suspend(self.queue)
            self.currentState = state
            
            let c: () -> () = {
                dispatch_resume(self.queue)
                completion?()
            }
            
            // Switch state and update the view
            dispatch_sync(dispatch_get_main_queue()) {
                switch state {
                case .None:
                    self.hideAllViews(animated: animated, completion: c)
                case .View(let viewKey):
                    self.showViewWithKey(viewKey, animated: animated, completion: c)
                }
            }
        }
    }
    
    
    // MARK: Private view updates
    
    private func showViewWithKey(state: String, animated: Bool, completion: (() -> ())? = nil) {
        if let newView = self.viewStore[state] {
            // Add new view using AutoLayout
            newView.alpha = animated ? 0.0 : 1.0
            newView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(newView)
            
            let views = ["view": newView]
            let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: [], metrics: nil, views: views)
            let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views)
            self.view.addConstraints(hConstraints)
            self.view.addConstraints(vConstraints)
        }
        
        let animations: () -> () = {
            if let newView = self.viewStore[state] {
                newView.alpha = 1.0
            }
        }
        
        let animationCompletion: (Bool) -> () = { (finished) in
            for (key, view) in self.viewStore {
                if !(key == state) {
                    view.removeFromSuperview()
                }
            }
            
            completion?()
        }
        
        animateChanges(animated: animated, animations: animations, animationCompletion: animationCompletion)
    }
    
    private func hideAllViews(animated animated: Bool, completion: (() -> ())? = nil) {
        let animations: () -> () = {
            for (_, view) in self.viewStore {
                view.alpha = 0.0
            }
        }
        
        let animationCompletion: (Bool) -> () = { (finished) in
            for (_, view) in self.viewStore {
                view.removeFromSuperview()
            }
            
            completion?()
        }
        
        animateChanges(animated: animated, animations: animations, animationCompletion: animationCompletion)
    }
    
    private func animateChanges(animated animated: Bool, animations: () -> (), animationCompletion: (Bool) -> ()) {
        if animated {
            UIView.animateWithDuration(0.3, animations: animations, completion: animationCompletion)
        } else {
            animationCompletion(true)
        }
    }
}
