//
//  ListView.swift
//  
//
//  Created by zhubch on 2017/6/29.
//  Copyright © 2017年 . All rights reserved.
//

import UIKit

let ViewModelPropertyKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "ViewModelPropertyKey".hashValue)
let EnablePropertyKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "EnablePropertyKey".hashValue)
let RefreshControlPropertyKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "RefreshControlPropertyKey".hashValue)
let LoadMoreControlPropertyKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "LoadMoreControlPropertyKey".hashValue)

protocol Refreshable {
    var enableRefresh: Bool { get set}
    func beginRefreshing()
    func endRefreshing()
    func resetNextURL(_ url: URL?)
}


protocol ListView: NSObjectProtocol,Refreshable {
    
    var viewModel: ViewModel? { set get }
    
    var selectedModel: ListModel? { get }
    
    var selectedModels: [ListModel]? { get }

    func reload()
    
    func reloadSelectedCell()
    
    func scrollToIndexPath(_ indexPath: IndexPath, animated: Bool)
    
    var emptyView: EmptyView { get }
    
    func insert(at indexPath: IndexPath)
}

extension UITableView: ListView {

    var viewModel: ViewModel? {
        get {
            return objc_getAssociatedObject(self, ViewModelPropertyKey) as? ViewModel
        }
        
        set {
            objc_setAssociatedObject(self, ViewModelPropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            self.dataSource = newValue
            self.delegate = newValue
            newValue?.listView = self
            guard let modelCellTypes = newValue?.modelCellTypes else { return }
            for (modelType, cellType) in modelCellTypes {
                register(cellType.nib, forCellReuseIdentifier: modelType.cellIdentifier)
            }
        }
    }
    
    var selectedModel: ListModel? {
        guard let indexPath = indexPathForSelectedRow else { return nil }
        return viewModel?[indexPath]
    }
    
    var selectedModels: [ListModel]? {
        guard let indexPaths = indexPathsForSelectedRows,
        let viewModel = viewModel else { return nil }
        return indexPaths.map{viewModel[$0]}
    }
    
    func reload() {
        viewModel?.willReloadListHandler?(self)
        reloadData()
    }

    func reloadSelectedCell() {
        if let indexPath = indexPathForSelectedRow {
            self.reloadRows(at: [indexPath], with: .automatic)
            self.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func removeRedundantSeparator() {
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    }
    
    func scrollToIndexPath(_ indexPath: IndexPath, animated: Bool = true) {
        scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    func insert(at indexPath: IndexPath) {
        insertRows(at: [indexPath], with: .bottom)
    }
}

extension UICollectionView: ListView {
    
    var viewModel: ViewModel? {
        get {
            return objc_getAssociatedObject(self, ViewModelPropertyKey) as? ViewModel
        }
        
        set {
            objc_setAssociatedObject(self, ViewModelPropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            self.dataSource = newValue
            self.delegate = newValue
            newValue?.listView = self
            guard let modelCellTypes = newValue?.modelCellTypes else { return }
            for (modelType, cellType) in modelCellTypes {
                register(cellType.nib, forCellWithReuseIdentifier: modelType.cellIdentifier)
            }
        }
    }
    
    func reload() {
        viewModel?.configureEmptySettings(settings: emptyView.settings)
        viewModel?.willReloadListHandler?(self)
        reloadData()
    }
    
    var selectedModels: [ListModel]? {
        guard let indexPaths = indexPathsForSelectedItems,
            let viewModel = viewModel else { return nil }
        return indexPaths.map{viewModel[$0]}
    }
    
    var selectedModel: ListModel? {
        guard let indexPath = indexPathsForSelectedItems?.first else { return nil }
        return viewModel?[indexPath]
    }
    
    func reloadSelectedCell() {
        if let indexPaths = indexPathsForSelectedItems {
            reloadItems(at: indexPaths)
            deleteItems(at: indexPaths)
        }
    }
    
    func scrollToIndexPath(_ indexPath: IndexPath, animated: Bool = true) {
        scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
    
    func insert(at indexPath: IndexPath) {
        insertItems(at: [indexPath])
    }
}

extension ListView where Self: UIScrollView {
    
    var emptyView: EmptyView {
        func createEmptyView() -> EmptyView {
            let v: EmptyView = Bundle.loadNib("EmptyView")!
            v.frame = self.bounds
            v.tag = 46544654
            v.isHidden = true
            addSubview(v)
            return v
        }
        return self.viewWithTag(46544654) as? EmptyView ?? createEmptyView()
    }
    
    var enableRefresh: Bool {
        get {
            return objc_getAssociatedObject(self, EnablePropertyKey) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, EnablePropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            if newValue == false {
                self.refreshControl.removeFromSuperview()
                self.unobserve()
            } else {
                self.addRefreshControl()
            }
        }
    }
    
    var refreshControl: UIRefreshControl {
        guard let refreshControl = objc_getAssociatedObject(self, RefreshControlPropertyKey) as? UIRefreshControl else {
            let control = UIRefreshControl(x: (C.windowWidth - 40) * 0.5, y: -40, w: 40, h: 40)
            addSubview(control)
            _ = control.rx.controlEvent(.valueChanged).takeUntil(rx.deallocated).subscribe({ _ in
                self.viewModel?.loadData()
            })
            objc_setAssociatedObject(self, RefreshControlPropertyKey, control, .OBJC_ASSOCIATION_RETAIN)
            return control
        }
        return refreshControl
    }
    
    var loadMoreControl: LoadMoreControl {
        guard let loadMoreControl = objc_getAssociatedObject(self, LoadMoreControlPropertyKey) as? LoadMoreControl else {
            let control = LoadMoreControl.defaultControl
            objc_setAssociatedObject(self, LoadMoreControlPropertyKey, control, .OBJC_ASSOCIATION_RETAIN)
            return control
        }
        return loadMoreControl
    }
    
    func beginRefreshing() {
        addRefreshControl()
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
    }
    
    func endRefreshing() {
        addRefreshControl()
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func addRefreshControl() {
        if self.refreshControl.superview == nil && enableRefresh {
            self.addSubview(refreshControl)
        }
    }
    
    func resetNextURL(_ url: URL?) {
        loadMoreControl.nextURL = url
        
        if let _ = url {
            observe()
        } else {
            unobserve()
        }
    }
    
    private func observe() {
        unobserve()
        if enableRefresh == false {
            return
        }
        loadMoreControl.dispose = self.rx
            .didScroll
            .takeUntil(rx.deallocated)
            .subscribe { [weak self] event in
                guard let this = self else { return }
                print(this.contentSize)
                print(this.contentOffset)
                print(this.h)
                if (this.contentSize.height - this.contentOffset.y - this.h) < 100 {
                    this.unobserve()
                    this.viewModel?.loadMore(nextURL: this.loadMoreControl.nextURL!)
                }
        }
    }
    
    private func unobserve() {
        loadMoreControl.dispose?.dispose()
        loadMoreControl.dispose = nil
    }
}

extension UIScrollView {
    var allInset: UIEdgeInsets {
        get {
            return contentInset
        }
        set(value) {
            contentInset = value
            scrollIndicatorInsets = value
        }
    }
    
    var allInsetTop: CGFloat {
        get {
            return contentInset.top
        }
        set(value) {
            contentInset.top = value
            scrollIndicatorInsets.top = value
        }
    }
    
    var allInsetLeft: CGFloat {
        get {
            return contentInset.left
        }
        set(value) {
            contentInset.left = value
            scrollIndicatorInsets.left = value
        }
    }
    
    var allInsetBottom: CGFloat {
        get {
            return contentInset.bottom
        }
        set(value) {
            contentInset.bottom = value
            scrollIndicatorInsets.bottom = value
        }
    }
    
    var allInsetRight: CGFloat {
        get {
            return contentInset.right
        }
        set(value) {
            contentInset.right = value
            scrollIndicatorInsets.right = value
        }
    }
}

typealias ListViewConfigureCellHandler = (_ cell: ListCell, _ indexPath: IndexPath) -> Void
typealias ListViewForSectionHandler = (_ section: Int) -> UIView?
typealias ListViewHeightForRowHandler = (_ indexPath: IndexPath) -> CGFloat
typealias ListViewWidthForRowHandler = (_ indexPath: IndexPath) -> CGFloat
typealias ListViewHeightForSectionHandler = (_ section: Int) -> CGFloat
typealias ListViewDidSelectModelHandler = (_ model: ListModel) -> Void
typealias ListViewDidScrollHandler = (_ scrollView: UIScrollView) -> Void
typealias ListViewWillBeginDraggingHandler = (_ scrollView: UIScrollView) -> Void
typealias ListViewDidEndDraggingHandler = (_ scrollView: UIScrollView, _ decelerate: Bool) -> Void
typealias ListViewInsetsForSectionHandler = (_ section: Int) -> UIEdgeInsets
typealias ListViewWillReloadHandler = (_ listView: ListView) -> Void
