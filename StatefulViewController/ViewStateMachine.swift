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
    case none			// No view shown
    case view(String)	// View with specific key is shown
}

public func == (lhs: ViewStateMachineState, rhs: ViewStateMachineState) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none): return true
    case (.view(let lName), .view(let rName)): return lName == rName
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
    fileprivate var viewStore: [String: UIView]
    fileprivate let queue = DispatchQueue(label: "com.aschuch.viewStateMachine.queue", attributes: [])
    
    /// The view that should act as the superview for any added views
    public let view: UIView
    
    /// The current display state of views
    public fileprivate(set) var currentState: ViewStateMachineState = .none

    /// The last state that was enqueued
    public fileprivate(set) var lastState: ViewStateMachineState = .none
    
    
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
    public func viewForState(_ state: String) -> UIView? {
        return viewStore[state]
    }
    
    /// Associates a view for the given state
    public func addView(_ view: UIView, forState state: String) {
        viewStore[state] = view
    }
    
    ///  Removes the view for the given state
    public func removeViewForState(_ state: String) {
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
    public func transitionToState(_ state: ViewStateMachineState, animated: Bool = true, completion: (() -> ())? = nil) {
        lastState = state
        
        queue.async {
            if state == self.currentState {
                return
            }
            
            // Suspend the queue, it will be resumed in the completion block
            self.queue.suspend()
            self.currentState = state
            
            let c: () -> () = {
                self.queue.resume()
                completion?()
            }
            
            // Switch state and update the view
            DispatchQueue.main.sync {
                switch state {
                case .none:
                    self.hideAllViews(animated: animated, completion: c)
                case .view(let viewKey):
                    self.showView(forKey: viewKey, animated: animated, completion: c)
                }
            }
        }
    }
    
    
    // MARK: Private view updates
    
    fileprivate func showView(forKey state: String, animated: Bool, completion: (() -> ())? = nil) {
        if let newView = self.viewStore[state] {
            // Add new view using AutoLayout
            newView.alpha = animated ? 0.0 : 1.0
            newView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(newView)

            let insets = (newView as? StatefulPlaceholderView)?.placeholderViewInsets() ?? UIEdgeInsets()
            let metrics = ["top": insets.top, "bottom": insets.bottom, "left": insets.left, "right": insets.right]
            let views = ["view": newView]

            let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-left-[view]-right-|", options: [], metrics: metrics, views: views)
            let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[view]-bottom-|", options: [], metrics: metrics, views: views)
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
        
        animateChanges(animated: animated, animations: animations, completion: animationCompletion)
    }
    
    fileprivate func hideAllViews(animated: Bool, completion: (() -> ())? = nil) {
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
        
        animateChanges(animated: animated, animations: animations, completion: animationCompletion)
    }
    
    fileprivate func animateChanges(animated: Bool, animations: @escaping () -> (), completion: ((Bool) -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: animations, completion: completion)
        } else {
            completion?(true)
        }
    }
}
