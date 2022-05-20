//
//  CollectionDragSortViewController.swift
//  DemosInSwift
//
//  Created by 古创 on 2021/9/9.
//  Copyright © 2021 c. All rights reserved.
//

import UIKit

class CollectionDragSortViewController: UIViewController {
    
    var pageIndex: Int
    var items: [HomeItem]
    
    init(pageIndex: Int, items: [HomeItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// scrollView是否正在翻页
    var isTurningPage = false
    var isShaking = false
    var isInsertingItem = false
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = ConstHelper.itemSize
        layout.minimumLineSpacing = adapter(10)
        layout.minimumInteritemSpacing = adapter(5)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        return layout
    }()   
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib.init(nibName: "DragSortCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.contentSize = CGSize(width: kScreenW * 2, height: kScreenH - adapter(120))
        return collection
    }()

    var isStartDragInMain:Bool = false // 开始拖拽是否在collectionView中
    var dragingIndexPath:IndexPath?
    var insideCell:DragSortCollectionCell? // 拖拽的cell
    var didMoveToDifferentCollection:Bool = false // 是否移动cell到不同的collection中
    
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
        setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(startEditing), name: NSNotification.Name("startEditing"), object: nil)
    }
    
    @objc private func startEditing() {
        for item in items {
            item.isEditing = true
        }
        collectionView.reloadData()
        collectionView.beginInteractiveMovementForItem(at: <#T##IndexPath#>)
    }

}

// MARK; - setUI
extension CollectionDragSortViewController {
    func setUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-120)
        }
    }
    
    @objc private func pageJump(x: CGFloat) {
        if isTurningPage { return }
        
        if x <= ConstHelper.pageLeftJumpX {
            if collectionView.contentOffset.x == 0 { return }
            let offset = CGPoint(x: collectionView.contentOffset.x - kScreenW, y: 0)
            collectionView.setContentOffset(offset, animated: true)
            isTurningPage = true
        } else if x >= ConstHelper.pageRightJumpX {
            if collectionView.contentOffset.x == 2 * kScreenW { return }
            let offset = CGPoint(x: collectionView.contentOffset.x + kScreenW, y: 0)
            collectionView.setContentOffset(offset, animated: true)
            isTurningPage = true
        }
    }
        
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CollectionDragSortViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DragSortCollectionCell
        cell.item = items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        if !didMoveToDifferentCollection {
//            // 如果只是在本collection中移动
//            if collectionView == collectionView {
//                var dataSource = DataSourceManager.main.mainDataSource
//                let item = dataSource[sourceIndexPath.section].remove(at: sourceIndexPath.row)
//                dataSource[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
//                DataSourceManager.main.mainDataSource = dataSource
//            }
////            if collectionView == bottomCollectionView {
////                var dataSource = DataSourceManager.main.bottomDataSource
////                let item = dataSource.remove(at: sourceIndexPath.row)
////                dataSource.insert(item, at: destinationIndexPath.row)
////                DataSourceManager.main.bottomDataSource = dataSource
////            }
//        } else {
//            // 如果是从collectionView和bottomCollectionView中的一个移到了另一个
//            if collectionView == collectionView {
//                var dataSource = DataSourceManager.main.mainDataSource
//                let item = dataSource[sourceIndexPath.section].remove(at: sourceIndexPath.row)
//                dataSource[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
//                DataSourceManager.main.mainDataSource = dataSource
//            }
////            if collectionView == bottomCollectionView {
////                var dataSource = DataSourceManager.main.bottomDataSource
////                let item = dataSource.remove(at: sourceIndexPath.row)
////                dataSource.insert(item, at: destinationIndexPath.row)
////                DataSourceManager.main.bottomDataSource = dataSource
////            }
//        }
    }
}

extension CollectionDragSortViewController {
    
}
