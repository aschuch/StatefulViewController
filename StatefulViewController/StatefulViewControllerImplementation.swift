import UIKit


// MARK: Default Implementation BackingViewProvider

extension BackingViewProvider where Self: UIViewController {
    public var backingView: UIView {
        return view
    }
}

extension BackingViewProvider where Self: UIView {
    public var backingView: UIView {
        return self
    }
}


// MARK: Default Implementation StatefulViewController

/// Default implementation of StatefulViewController for UIViewController
extension StatefulViewController {
    
    public var stateMachine: ViewStateMachine {
        return associatedObject(self, key: &stateMachineKey) { [unowned self] in
            return ViewStateMachine(view: self.backingView)
        }
    }
    
    public var currentState: StatefulViewControllerState {
        switch stateMachine.currentState {
        case .none: return .Content
        case .view(let viewKey): return StatefulViewControllerState(rawValue: viewKey)!
        }
    }
    
    public var lastState: StatefulViewControllerState {
        switch stateMachine.lastState {
        case .none: return .Content
        case .view(let viewKey): return StatefulViewControllerState(rawValue: viewKey)!
        }
    }
    
    
    // MARK: Views
    
    public var loadingView: UIView? {
        get { return placeholderView(.Loading) }
        set { setPlaceholderView(newValue, forState: .Loading) }
    }
    
    public var errorView: UIView? {
        get { return placeholderView(.Error) }
        set { setPlaceholderView(newValue, forState: .Error) }
    }
    
    public var emptyView: UIView? {
        get { return placeholderView(.Empty) }
        set { setPlaceholderView(newValue, forState: .Empty) }
    }
    
    
    // MARK: Transitions
    
    public func setupInitialViewState(_ completion: (() -> Void)? = nil) {
        let isLoading = (lastState == .Loading)
        let error: NSError? = (lastState == .Error) ? NSError(domain: "com.aschuch.StatefulViewController.ErrorDomain", code: -1, userInfo: nil) : nil
        transitionViewStates(loading: isLoading, error: error, animated: false, completion: completion)
    }
    
    public func startLoading(animated: Bool = false, completion: (() -> Void)? = nil) {
        transitionViewStates(loading: true, animated: animated, completion: completion)
    }
    
    public func endLoading(animated: Bool = true, error: Error? = nil, completion: (() -> Void)? = nil) {
        transitionViewStates(loading: false, error: error, animated: animated, completion: completion)
    }
    
    public func transitionViewStates(loading: Bool = false, error: Error? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        // Update view for content (i.e. hide all placeholder views)
        if hasContent() {
            if let e = error {
                // show unobstrusive error
                handleErrorWhenContentAvailable(e)
            }
            self.stateMachine.transitionToState(.none, animated: animated, completion: completion)
            return
        }
        
        // Update view for placeholder
        var newState: StatefulViewControllerState = .Empty
        if loading {
            newState = .Loading
        } else if let _ = error {
            newState = .Error
        }
        self.stateMachine.transitionToState(.view(newState.rawValue), animated: animated, completion: completion)
    }
    
    
    // MARK: Content and error handling
    
    public func hasContent() -> Bool {
        return true
    }
    
    public func handleErrorWhenContentAvailable(_ error: Error) {
        // Default implementation does nothing.
    }
    
    
    // MARK: Helper
    
    fileprivate func placeholderView(_ state: StatefulViewControllerState) -> UIView? {
        return stateMachine[state.rawValue]
    }
    
    fileprivate func setPlaceholderView(_ view: UIView?, forState state: StatefulViewControllerState) {
        stateMachine[state.rawValue] = view
    }
}


// MARK: Association

private var stateMachineKey: UInt8 = 0

private func associatedObject<T: AnyObject>(_ host: AnyObject, key: UnsafeRawPointer, initial: () -> T) -> T {
    var value = objc_getAssociatedObject(host, key) as? T
    if value == nil {
        value = initial()
        objc_setAssociatedObject(host, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
    return value!
}
