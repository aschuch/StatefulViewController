//
//  StatefulPlaceholderView.swift
//  Example
//
//  Created by Alexander Schuch on 13/04/16.
//  Copyright © 2016 Alexander Schuch. All rights reserved.
//

import UIKit

public protocol StatefulPlaceholderView {
    /// Defines the insets to apply when presented via the `StatefulViewController`
    /// Return insets here in order to inset the current placeholder view from the edges 
    /// of the parent view.
    func placeholderViewInsets() -> UIEdgeInsets
}

extension StatefulPlaceholderView {

    public func placeholderViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets()
    }

}
