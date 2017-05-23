//
//  RefinementCollectionWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

/// Widget that displays facet values for an attribute and lets the user filter the results using these values. 
/// Built over a `UICollectionView`.
/// Possible configurable parameters are:
/// - attribute
/// - refinedFirst
/// - operator
/// - sortBy
/// - limit
/// + Note: This is best used with a RefinementController (through composition) 
/// or a RefinementCollectionViewController (through inheritance).
@objc public class RefinementCollectionWidget: UICollectionView, RefinementMenuViewDelegate, AlgoliaWidget {
        
    @IBInspectable public var attribute: String = Constants.Defaults.attribute
    @IBInspectable public var refinedFirst: Bool = Constants.Defaults.refinedFirst
    @IBInspectable public var `operator`: String = Constants.Defaults.operatorRefinement
    @IBInspectable public var sortBy: String = Constants.Defaults.sortBy
    @IBInspectable public var limit: Int = Constants.Defaults.limit
    
    var viewModel: RefinementMenuViewModelDelegate
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        viewModel = RefinementMenuViewModel()
        super.init(frame: frame, collectionViewLayout: layout)
        viewModel.view = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = RefinementMenuViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    public func reloadRefinements() {
        reloadData()
    }
    
    func deselectRow(at indexPath: IndexPath) {
        deselectItem(at: indexPath, animated: true)
    }
}
