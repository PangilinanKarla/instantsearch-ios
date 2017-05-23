//
//  TwoValueSwitchWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 03/05/2017.
//
//

import Foundation

/// Widget that controls the facet value of attribute. Built on top of `UISwitch`.
/// Possible configurable parameters are:
/// - attribute
/// - valueOn
/// - valueOff
/// - inclusive
/// + Note: Use this for boolean values. (Example: "Sale" and "no sale")
@objc public class TwoValuesSwitchWidget: SwitchWidget {
    @IBInspectable public var valueOff: String = Constants.Defaults.valueOff
    
    override public func configureView() {
        addTarget(self, action: #selector(facetValueChanged), for: .valueChanged)
        if isOn {
            viewModel.updatefacet(oldValue: valueOff, newValue: valueOn, doSearch: false)
        } else {
            viewModel.updatefacet(oldValue: valueOn, newValue: valueOff, doSearch: false)
        }
    }
    
    @objc private func facetValueChanged() {
        if isOn {
            viewModel.updatefacet(oldValue: valueOff, newValue: valueOn, doSearch: true)
        } else {
            viewModel.updatefacet(oldValue: valueOn, newValue: valueOff, doSearch: true)
        }
    }
    
    public override func set(value: String) {
        if value == valueOn {
            setOn(true, animated: true)
        } else if value == valueOff {
            setOn(false, animated: true)
        }
        
    }
}
