//
//  ConstHelper.swift
//  DragDemo
//
//  Created by Allen long on 2022/5/11.
//

import Foundation
import UIKit

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
// 获取状态栏高度
public var statusBarHeight:CGFloat {
    if #available(iOS 13.0, *) {
        let nowWindow = UIApplication.shared.windows.first
        let statusBarManager = nowWindow?.windowScene?.statusBarManager
        return statusBarManager?.statusBarFrame.size.height ?? 0
    }
    return UIApplication.shared.statusBarFrame.size.height
}


struct ConstHelper {
    static let itemSize = CGSize(width: adapter(80), height: adapter(100))
    static let lineSpacing = adapter(10)
    static let itemSpacing = adapter(5)
    static let collectionViewContentInset = UIEdgeInsets(top: statusBarHeight + 20, left: 20, bottom: 0, right: 18)
    
    // 触发页面向左滑动时，collectionItem的origin.x
    static let pageLeftJumpX : CGFloat = adapter(10)
    // 触发页面向右滑动时，collectionItem的origin.x
    static let pageRightJumpX : CGFloat = kScreenW - itemSize.width - adapter(10)
}
