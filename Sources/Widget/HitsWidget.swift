//
//  HitsWidget.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/04/2019.
//

import Foundation
import InstantSearchCore

public protocol HitsWidget: class {
  
  associatedtype Hit: Codable
  
  var viewModel: HitsViewModel<Hit>? { get set }
  
  func reload()
  
  func scrollToTop()
  
}

public protocol HitsSource: class {
  
  associatedtype Record: Codable
  
  func numberOfHits() -> Int
  func hit(atIndex index: Int) -> Record?
  
}

extension HitsViewModel: HitsSource {}
