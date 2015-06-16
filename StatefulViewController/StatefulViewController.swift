//
//  StatefulViewController.swift
//  StatefulViewController
//
//  Created by Alexander Schuch on 30/07/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit

/// Represents all possible states of this view controller
public enum StatefulViewControllerState: String {
    case Content = "content"
    case Loading = "loading"
    case Error = "error"
    case Empty = "empty"
}

/// Delegate protocol
@objc public protocol StatefulViewControllerDelegate {
    /// Return true if content is available in your controller.
    ///
    /// :returns: true if there is content available in your controller.
    ///
    func hasContent() -> Bool
    
    /// This method is called if an error occured, but `hasContent` returned true.
    /// You would typically display an unobstrusive error message that is easily dismissable
    /// for the user to continue browsing content.
    ///
    /// :param: error	The error that occured
    ///
    optional func handleErrorWhenContentAvailable(error: NSError)
}

private var stateMachineAssociationKey: UInt8 = 0
private var loadingViewAssociationKey: UInt8 = 0
private var errorViewAssociationKey: UInt8 = 0
private var emptyViewAssociationKey: UInt8 = 0

///
/// A view controller subclass that presents placeholder views based on content, loading, error or empty states.
///
extension UIViewController {

    private var stateMachine: ViewStateMachine! {
        get {
            var value = objc_getAssociatedObject(self, &stateMachineAssociationKey) as? ViewStateMachine
            if value == nil
            {
                value = ViewStateMachine(view: self.view)
                objc_setAssociatedObject(self, &stateMachineAssociationKey, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &stateMachineAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    /// The current state of the view controller.
    /// All states other than `Content` imply that there is a placeholder view shown.
    public var currentState: StatefulViewControllerState {
        switch stateMachine.currentState {
        case .None: return .Content
        case .View(let viewKey): return StatefulViewControllerState(rawValue: viewKey)!
        }
    }
    
    public var lastState: StatefulViewControllerState {
        switch stateMachine.lastState {
        case .None: return .Content
        case .View(let viewKey): return StatefulViewControllerState(rawValue: viewKey)!
        }
    }
    
    // MARK: Views
    
    /// The loading view is shown when the `startLoading` method gets called
    public var loadingView: UIView! {
        get {
            return objc_getAssociatedObject(self, &loadingViewAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &loadingViewAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
            setPlaceholderView(newValue, forState: .Loading)
        }
    }
    
    /// The error view is shown when the `endLoading` method returns an error
    public var errorView: UIView! {
        get {
            return objc_getAssociatedObject(self, &errorViewAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &errorViewAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
            setPlaceholderView(newValue, forState: .Error)
        }
    }
    
    /// The empty view is shown when the `hasContent` method returns false
    public var emptyView: UIView! {
        get {
            return objc_getAssociatedObject(self, &emptyViewAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &emptyViewAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
            setPlaceholderView(newValue, forState: .Empty)
        }
    }
    
    
    // MARK: UIViewController
    
    public func statefulViewWillAppear() {
        // Make sure to stay in the correct state when transitioning
        let isLoading = (lastState == .Loading)
        let error: NSError? = (lastState == .Error) ? NSError() : nil
        transitionViewStates(loading: isLoading, error: error, animated: false)
    }
    
    
    // MARK: Start and stop loading
    
    /// Transitions the controller to the loading state and shows
    /// the loading view if there is no content shown already.
    ///
    /// :param: animated 	true if the switch to the placeholder view should be animated, false otherwise
    ///
    public func startLoading(animated: Bool = false, completion: (() -> ())? = nil) {
        transitionViewStates(loading: true, animated: animated, completion: completion)
    }
    
    /// Ends the controller's loading state.
    /// If an error occured, the error view is shown.
    /// If the `hasContent` method returns false after calling this method, the empty view is shown.
    ///
    /// :param: animated 	true if the switch to the placeholder view should be animated, false otherwise
    /// :param: error		An error that might have occured whilst loading
    ///
    public func endLoading(animated: Bool = true, error: NSError? = nil, completion: (() -> ())? = nil) {
        transitionViewStates(loading: false, animated: animated, error: error, completion: completion)
    }
    
    
    // MARK: Update view states
    
    /// Transitions the view to the appropriate state based on the `loading` and `error`
    /// input parameters and shows/hides corresponding placeholder views.
    ///
    /// :param: loading		true if the controller is currently loading
    /// :param: error		An error that might have occured whilst loading
    /// :param: animated	true if the switch to the placeholder view should be animated, false otherwise
    ///
    public func transitionViewStates(loading: Bool = false, error: NSError? = nil, animated: Bool = true, completion: (() -> ())? = nil) {
        let hasContent = (self as? StatefulViewControllerDelegate)?.hasContent() ?? true
        
        // Update view for content (i.e. hide all placeholder views)
        if hasContent {
            if let e = error {
                // show unobstrusive error
                (self as? StatefulViewControllerDelegate)?.handleErrorWhenContentAvailable?(e)
            }
            self.stateMachine.transitionToState(.None, animated: animated, completion: completion)
            return
        }
        
        // Update view for placeholder
        var newState: StatefulViewControllerState = .Empty
        if loading {
            newState = .Loading
        } else if let e = error {
            newState = .Error
        }
        self.stateMachine.transitionToState(.View(newState.rawValue), animated: animated, completion: completion)
    }
    
    
    // MARK: Helper
    
    private func setPlaceholderView(view: UIView, forState state: StatefulViewControllerState) {
        stateMachine[state.rawValue] = view
    }
}
