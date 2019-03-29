//
//  TableViewHitsWidget.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public typealias TableViewCellConfigurator<Hit> = HitViewConfigurator<UITableView, UITableViewCell, Hit>
public typealias TableViewClickHandler<Hit> = HitClickHandler<UITableView, Hit>
public typealias TableViewHitsController<Hit: Codable> = HitsController<TableViewHitsWidget<Hit>>

open class TableViewHitsDataSource<DataSource: HitsSource>: NSObject, UITableViewDataSource {
  
  public var cellConfigurator: TableViewCellConfigurator<DataSource.Record>
  public weak var hitsDataSource: DataSource?
  
  public init(cellConfigurator: @escaping TableViewCellConfigurator<DataSource.Record>) {
    self.cellConfigurator = cellConfigurator
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsDataSource?.numberOfHits() ?? 0
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let hit = hitsDataSource?.hit(atIndex: indexPath.row) else {
      return UITableViewCell()
    }
    return cellConfigurator(tableView, hit, indexPath)
  }
  
}

open class TableViewHitsDelegate<DataSource: HitsSource>: NSObject, UITableViewDelegate {
  
  public var clickHandler: TableViewClickHandler<DataSource.Record>
  public weak var hitsDataSource: DataSource?
  
  public init(clickHandler: @escaping TableViewClickHandler<DataSource.Record>) {
    self.clickHandler = clickHandler
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let hit = hitsDataSource?.hit(atIndex: indexPath.row) else {
      return
    }
    clickHandler(tableView, hit, indexPath)
  }
  
}

public class TableViewHitsWidget<Hit: Codable>: NSObject, HitsWidget {
  
  public typealias ViewModel = HitsViewModel<Hit>
  
  public typealias SingleHitView = UITableViewCell
  
  public let tableView: UITableView
  
  public weak var viewModel: ViewModel? {
    didSet {
      dataSource?.hitsDataSource = viewModel
      delegate?.hitsDataSource = viewModel
    }
  }
  
  public var dataSource: TableViewHitsDataSource<ViewModel>? {
    didSet {
      dataSource?.hitsDataSource = viewModel
      tableView.dataSource = dataSource
    }
  }
  
  public var delegate: TableViewHitsDelegate<ViewModel>? {
    didSet {
      delegate?.hitsDataSource = viewModel
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
