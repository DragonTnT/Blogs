//
//  ViewController.swift
//  NewDragDemo
//
//  Created by Allen long on 2022/5/19.
//

import UIKit

class ViewController: UIViewController {
    
    let editingManager = HomeEditingManager.main
    
    var subVCs: [UIViewController] = [
        MessViewController()
    ]
    
    var bottomSubVC = BottomVC()
    
    lazy var scrollView: UIScrollView = {
        let it = UIScrollView(frame: self.view.bounds)
        it.isPagingEnabled = true
        it.backgroundColor = UIColor.white.withAlphaComponent(0)
        it.showsHorizontalScrollIndicator = false
        it.delegate = self
        return it
    }()
    
    lazy var outsideCell: DragSortCollectionCell = {
        let it = DragSortCollectionCell.loadViewFromNib()
        it.isHidden = true
        it.frame = CGRect(origin: .zero, size: ConstHelper.itemSize)
        view.addSubview(it)
        return it
    }()
    
    var outsideCellCenterOffset: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 默认在第二屏
        scrollView.contentOffset = CGPoint(x: kScreenW, y: 0)
        
        // TODO: 编辑状态和非编辑状态下，手势是否有两个
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        view.addGestureRecognizer(longPress)
    }
    
    private func setupUI() {
        // 添加滑动控制器
        for (index,pageSource) in DataSourceManager.main.mainDataSource.enumerated() {
            let vc = CollectionDragSortViewController(pageIndex: index, items: pageSource)
            subVCs.append(vc)
        }
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: kScreenW * CGFloat(subVCs.count), height: kScreenH)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        setupSubControllers()
        
        //添加底部控制器
        addChild(bottomSubVC)
        view.addSubview(bottomSubVC.view)
        bottomSubVC.view.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(120)
        }
    }

    private func setupSubControllers() {
        for (index,vc) in subVCs.enumerated() {
            addChild(vc)
            let origin = CGPoint(x: CGFloat(index) * view.bounds.width, y: 0)
            vc.view.frame = CGRect(origin: origin, size: view.bounds.size)
            scrollView.addSubview(vc.view)
        }
    }
    
    @objc func longPressAction(_ longPress: UILongPressGestureRecognizer) {
        switch longPress.state {
        case .began:
            print("开始")
            if !editingManager.isHomeEditing {
                editingManager.isHomeEditing = true
            }
            
            let point = longPress.location(in: self.view)
            editingManager.beginEditingAt(point, homeVC: self)
        default:
            return
        }
    }
    // MARK: - aciton
//    @objc func longPressAction(_ longPress: UILongPressGestureRecognizer) {
//        switch longPress.state {
//        case .began:
//            let point = longPress.location(in: view)
//            if judge(point: point, inRangeOf: mainCollectionView) {
//                isStartDragInMain = true
//                if let indexPath = mainCollectionView.indexPathForItem(at: longPress.location(in: mainCollectionView)) {
//                    insideCell = mainCollectionView.cellForItem(at: indexPath) as? DragSortCollectionCell
//                    insideCell?.isHidden = true
//                    outsideCell.isHidden = false
//                    outsideCell.titleLabel.text = insideCell?.titleLabel.text
//
//                    let position = insideCell!.convert(CGPoint(x: ConstHelper.itemSize.width/2, y: ConstHelper.itemSize.height/2), to: view)
//                    outsideCell.center = position
//                    outsideCellCenterOffset = CGPoint(x: position.x - point.x, y: position.y - point.y)
//
//                    mainCollectionView.beginInteractiveMovementForItem(at: indexPath)
//                    dragingIndexPath = indexPath
//
//                    startShake()
//                }
//            }
//            if judge(point: point, inRangeOf: bottomCollectionView) {
//                isStartDragInMain = false
//                if let indexPath = bottomCollectionView.indexPathForItem(at: longPress.location(in: bottomCollectionView)) {
//                    let cell = bottomCollectionView.cellForItem(at: indexPath) as! DragSortCollectionCell
//                    view.bringSubviewToFront(cell)
//                    bottomCollectionView.beginInteractiveMovementForItem(at: indexPath)
//                    dragingIndexPath = indexPath
//                    insideCell = cell
//                    startShake()
//                }
//            }
//        case .changed:
//            let point = longPress.location(in: view)
//            if isStartDragInMain {
//                if judge(point: point, inRangeOf: mainCollectionView) {
//                    let location = longPress.location(in: mainCollectionView)
//                    let position = CGPoint(x: location.x + outsideCellCenterOffset.x, y: location.y + outsideCellCenterOffset.y)
//                    mainCollectionView.updateInteractiveMovementTargetPosition(position)
//                    outsideCell.center = CGPoint(x: point.x + outsideCellCenterOffset.x, y: point.y + outsideCellCenterOffset.y)
//
//                    let x = outsideCell.frame.origin.x
//                    if x <= ConstHelper.pageLeftJumpX || x >= ConstHelper.pageRightJumpX {
//                        pageJump(x: x)
//                    }
//                }
//                if judge(point: point, inRangeOf: bottomCollectionView) {
//                    if !isInsertingItem {
//                        // TODO: 尝试使用有车来中的布局，scrollView+bottomCollectionView.应该有一个顶层的homeItem，如果该item是在本collectionView中移动，则在moveItemAt代理方法中更新数据源；如果该item从一个collectionView切换到另一个collectionView，则在切换的时候，就更新数据源。
//                        // TODO: 考虑bottomCollectionView也用单独的控制器。这样主控制器就只管通过拖动手势来发出指令。
//
//                        let itemIndex = DataSourceManager.main.bottomDataSource.count
//                        let indexPath = IndexPath(item: itemIndex, section: 0)
//                        let item = HomeItem(title: "123", indexPath: indexPath)
//                        DataSourceManager.main.bottomDataSource.append(item)
//                        bottomCollectionView.insertItems(at: [indexPath])
//                        bottomCollectionView.beginInteractiveMovementForItem(at: indexPath)
//                        isInsertingItem = true
//                    }
//                    let location = longPress.location(in: bottomCollectionView)
//                    let position = CGPoint(x: location.x + outsideCellCenterOffset.x, y: location.y + outsideCellCenterOffset.y)
//                    bottomCollectionView.updateInteractiveMovementTargetPosition(position)
//                    outsideCell.center = CGPoint(x: point.x + outsideCellCenterOffset.x, y: point.y + outsideCellCenterOffset.y)
//                }
//
////                if judge(point: <#T##CGPoint#>, inRangeOf: <#T##UIView#>)
//
//            } else {
//                bottomCollectionView.updateInteractiveMovementTargetPosition(longPress.location(in: bottomCollectionView))
//                if !judge(point: point, inRangeOf: bottomCollectionView) {
//                    if let _ = dragingIndexPath, let cell = insideCell {
//                        if !view.subviews.contains(cell) { // 从collection中移除而加到view上
//                            cell.removeFromSuperview()
//                            view.addSubview(cell)
//                        }
//                        cell.center = point
//                    }
//                }
//            }
//
//        case .ended:
//            isInsertingItem = false
//            insideCell?.isHidden = false
//            outsideCell.isHidden = true
//            let point = longPress.location(in: view)
//            if isStartDragInMain {
//
//                if judge(point: point, inRangeOf: mainCollectionView) {
//                    didMoveToDifferentCollection = false
//                }
//
//                if judge(point: point, inRangeOf: bottomCollectionView) { // 如果从main拖到bottom了
//                    if let indexPath = dragingIndexPath, let _ = insideCell {
//                        var section = DataSourceManager.main.mainDataSource[indexPath.section]
//                        let item = section.remove(at: indexPath.row)
//                        DataSourceManager.main.mainDataSource[indexPath.section] = section
//                        DataSourceManager.main.bottomDataSource.append(item)
//                        didMoveToDifferentCollection = true
//                        mainCollectionView.reloadData()
//                        bottomCollectionView.reloadData()
//                    }
//                }
//
//                mainCollectionView.endInteractiveMovement()
//            } else {
//                if judge(point: point, inRangeOf: mainCollectionView) { // 如果从bottom拖到main了
//                    if let indexPath = dragingIndexPath, let _ = insideCell {
//                        let item = DataSourceManager.main.bottomDataSource.remove(at: indexPath.row)
//                        var section = DataSourceManager.main.mainDataSource[indexPath.section]
//                        section.append(item)
//                        DataSourceManager.main.mainDataSource[indexPath.section] = section
//                        didMoveToDifferentCollection = true
//                        mainCollectionView.reloadData()
//                        bottomCollectionView.reloadData()
//                    }
//                }
//                if judge(point: point, inRangeOf: bottomCollectionView) {
//                    didMoveToDifferentCollection = false
//                }
//                bottomCollectionView.endInteractiveMovement()
//            }
//            stopShake()
//        default:
//            if let follow = insideCell {
//                if view.subviews.contains(follow) {
//                    follow.removeFromSuperview()
//                }
//            }
//            if isStartDragInMain {
//                mainCollectionView.cancelInteractiveMovement()
//            } else {
//                bottomCollectionView.cancelInteractiveMovement()
//            }
//            stopShake()
//            return
//        }
//    }
    
    // 判断点是否在view内
    func judge(point:CGPoint, inRangeOf targetView:UIView) -> Bool {
        if point.x < targetView.frame.minX {
            return false
        }
        if point.x > targetView.frame.maxX {
            return false
        }
        if point.y < targetView.frame.minY {
            return false
        }
        if point.y > targetView.frame.maxY {
            return false
        }
        return true
    }

}

extension ViewController: UIScrollViewDelegate {
    
}

