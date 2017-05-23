//
//  OneValueSwitchWidget.swift
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
/// - inclusive
/// + Note: Use this for one possible value. (Example: "premium")
@objc public class OneValueSwitchWidget: SwitchWidget {
    override public func configureView() {
        addTarget(self, action: #selector(facetValueChanged), for: .valueChanged)
    }
    
    @objc private func facetValueChanged() {
        if isOn {
            viewModel.addFacet(value: valueOn, doSearch: true)
        } else {
            viewModel.removeFacet(value: valueOn)
        }
    }
}
