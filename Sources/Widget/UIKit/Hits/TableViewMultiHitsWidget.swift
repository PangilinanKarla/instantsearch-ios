//
//  TableViewMultiHitsWidget.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 25/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

open class TableViewMultiHitsDataSource: NSObject {
  
  private typealias CellConfigurator = (UITableView, Int) throws -> UITableViewCell
  
  public weak var hitsSource: MultiHitsSource? {
    didSet {
      cellConfigurators.removeAll()
    }
  }
  
  private var cellConfigurators: [Int: CellConfigurator]
  
  public override init() {
    cellConfigurators = [:]
    super.init()
  }
  
  public func setCellConfigurator<Hit: Codable>(forSection section: Int, _ cellConfigurator: @escaping TableViewCellConfigurator<Hit>) {
    cellConfigurators[section] = { [weak self] (tableView, row) in
      guard let hit: Hit = try self?.hitsSource?.hit(atIndex: row, inSection: section) else {
        assertionFailure("Invalid state: Attempt to deqeue a cell for a missing hit in a hits ViewModel")
        return UITableViewCell()
      }
      return cellConfigurator(tableView, hit, IndexPath(row: row, section: section))
    }
  }
  
}

extension TableViewMultiHitsDataSource: UITableViewDataSource {
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    guard let numberOfSections = hitsSource?.numberOfSections() else {
      return 0
    }
    return numberOfSections
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let numberOfRows = hitsSource?.numberOfHits(inSection: section) else {
      return 0
    }
    return numberOfRows
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    do {
      return try cellConfigurators[indexPath.section]?(tableView, indexPath.row) ?? UITableViewCell()
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}

open class TableViewMultiHitsDelegate: NSObject {
  
  typealias ClickHandler = (UITableView, Int) throws -> Void
  
  public weak var hitsSource: MultiHitsSource? {
    didSet {
      clickHandlers.removeAll()
    }
  }
  
  private var clickHandlers: [Int: ClickHandler]
  
  public override init() {
    clickHandlers = [:]
    super.init()
  }
  
  public func setClickHandler<Hit: Codable>(forSection section: Int, _ clickHandler: @escaping TableViewClickHandler<Hit>) {
    clickHandlers[section] = { [weak self] (tableView, row) in
      guard let hit: Hit = try self?.hitsSource?.hit(atIndex: row, inSection: section) else {
        assertionFailure("Invalid state: Attempt to process a click of a cell for a missing hit in a hits ViewModel")
        return
      }
      clickHandler(tableView, hit, IndexPath(row: row, section: section))
    }
  }
  
}

extension TableViewMultiHitsDelegate: UITableViewDelegate {
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    do {
      try clickHandlers[indexPath.section]?(tableView, indexPath.row)
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}

public class TableViewMultiHitsWidget: NSObject, MultiHitsWidget {
  
  public typealias SingleHitView = UITableViewCell
  
  public let tableView: UITableView
  
  public weak var viewModel: MultiHitsViewModel? {
    didSet {
      dataSource?.hitsSource = viewModel
      delegate?.hitsSource = viewModel
    }
  }
  
  public var dataSource: TableViewMultiHitsDataSource? {
    didSet {
      dataSource?.hitsSource = viewModel
      tableView.dataSource = dataSource
    }
  }
  
  public var delegate: TableViewMultiHitsDelegate? {
    didSet {
      delegate?.hitsSource = viewModel
      tableView.delegate = delegate
    }
  }
  
  public init(tableView: UITableView) {
    self.tableView = tableView
  }
  
  public func reload() {
    tableView.reloadData()
  }
  
  public func scrollToTop() {
    tableView.scrollToRow(at: IndexPath(), at: .top, animated: false)
  }

}
