//
//  ViewModel.swift
//  
//
//  Created by zhubch on 2017/6/29.
//  Copyright © 2017年 . All rights reserved.
//

import UIKit

class ViewModel: NSObject {
    
    weak var listView: ListView?
    
    var reuseCell = true // 不建议使用false
    
    var loadingStatus: EmptyView.EmptyStatus = .loading {
        didSet {
            guard let emptyView = listView?.emptyView else { return }
            configureEmptySettings(settings: emptyView.settings)
            emptyView.status = loadingStatus
        }
    }
    
    var selectedColor = C.Color.gray * 0.06
    
    var autoDeselect = true
    
    var cellWidth: CGFloat = 0
    
    var cellHeight: CGFloat = 0
    
    var cellInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    var sections: [[ListModel]] = [[]] 
    
    var modelCellTypes: [(ListModel.Type, ListCell.Type)]?
    
    var modelCellType: (ListModel.Type, ListCell.Type)! {
        didSet {
            modelCellTypes = [modelCellType]
        }
    }
    
    var willReloadListHandler: ListViewWillReloadHandler?
        
    var configureCellHandler: ListViewConfigureCellHandler?
    
    var viewForHeaderHandler: ListViewForSectionHandler?
    
    var viewForFooterHandler: ListViewForSectionHandler?
    
    var heightForRowHandler: ListViewHeightForRowHandler?
    
    var widthForRowHandler: ListViewWidthForRowHandler?
    
    var heightForHeaderHandler: ListViewHeightForSectionHandler?
    
    var heightForFooterHandler: ListViewHeightForSectionHandler?
    
    var didSelectModelHandler: ListViewDidSelectModelHandler?
    
    var didDeselectModelHandler: ListViewDidSelectModelHandler?
    
    var didScrollHandler: ListViewDidScrollHandler?
    
    var willBeginDraggingHandler: ListViewWillBeginDraggingHandler?
    
    var insetsForSectionHandler: ListViewInsetsForSectionHandler?
    
    subscript(indexPath: IndexPath) -> ListModel {
        get {
            return sections[indexPath.section][indexPath.row]
        }
        set {
            var items = sections[indexPath.section]
            items.insert(newValue, at: indexPath.row)
        }
    }
    
    final func remove(indexPath: IndexPath) {
        sections[indexPath.section].remove(at: indexPath.row)
    }
    
    final func numberOfSections() -> Int {
        return sections.count
    }
    
    final func numberOfRowsInSection(section: Int) -> Int {
        return sections[section].count
    }
    
    open func configureEmptySettings(settings: EmptySettings) {
        settings.reloadHandler = { self.loadData() }
        settings.errorImage = #imageLiteral(resourceName: "img_load_failed")
        settings.errorDesc = "加载失败，请点击刷新"
        settings.emptyImage = #imageLiteral(resourceName: "img_load_failed")
        settings.emptyDesc = "没有数据，请点击刷新"
    }
    
    open func loadData() {

    }
    
    open func loadMore(nextURL: URL) {

    }
    
    fileprivate func createCell(with model: ListModel) -> UITableViewCell? {
        guard let modelCellTypes = modelCellTypes else { return nil }
        let cellType = modelCellTypes.first { (modelCell) -> Bool in
            return type(of: model) == modelCell.0
        }?.1
        guard let type = cellType else { return nil }
        let cell: UITableViewCell? = Bundle.loadNib(String(describing: type))
        cell?.setValue(model, forKey: "model")
        return cell
    }
    
    deinit {
        print("deinit: " + String(describing: className))
    }
}

extension ViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = numberOfSections()
        tableView.emptyView.isHidden = count > 0 && (sections.first?.count ?? 0) > 0
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model  = self[indexPath]
        var cell = UITableViewCell()
        if reuseCell {
            let cellID = type(of: model).cellIdentifier
            cell   = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.setValue(model, forKey: "model")
        } else {
            cell   = createCell(with: model)!
        }

        if cell.backgroundView == nil {
            cell.backgroundView = UIView()
            cell.selectedBackgroundView?.backgroundColor = .white
        }
        
        if (cell.selectedBackgroundView?.tag ?? 0) != 4654 {
            cell.selectedBackgroundView = UIView()
            cell.selectedBackgroundView?.tag = 4654
            cell.selectedBackgroundView?.backgroundColor = selectedColor
        }
        
        configureCellHandler?(cell, indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = heightForRowHandler?(indexPath) ?? cellHeight
        return h > 0 ? h : UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectModelHandler?(self[indexPath])
        if autoDeselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectModelHandler?(self[indexPath])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderHandler?(section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooterHandler?(section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderHandler?(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterHandler?(section) ?? 0
    }
}

extension ViewModel: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = numberOfSections()
        collectionView.emptyView.isHidden = count > 0 && (sections.first?.count ?? 0) > 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model  = self[indexPath]
        let cellID = type(of: model).cellIdentifier
        let cell   = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        cell.perform(Selector(("setModel:")), with: model)
        
        configureCellHandler?(cell, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            return viewForFooterHandler?(indexPath.section) as! UICollectionReusableView
        }
        return viewForHeaderHandler?(indexPath.section) as! UICollectionReusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectModelHandler?(self[indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = selectedColor
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = widthForRowHandler?(indexPath) ?? cellWidth
        let h = heightForRowHandler?(indexPath) ?? cellHeight
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = insetsForSectionHandler?(section) ?? cellInsets
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let insets = insetsForSectionHandler?(section) ?? cellInsets
        return insets.right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let insets = insetsForSectionHandler?(section) ?? cellInsets
        return insets.bottom
    }
}

extension ViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollHandler?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDraggingHandler?(scrollView)
    }
}

