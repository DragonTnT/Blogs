//
//  HomeEditingManager.swift
//  NewDragDemo
//
//  Created by Allen long on 2022/5/20.
//

import Foundation
import UIKit

class HomeEditingManager {
    private init() {}
    static let main = HomeEditingManager()
    
    var isHomeEditing = false {
        didSet {
            if isHomeEditing {
                NotificationCenter.default.post(name: NSNotification.Name("startEditing"), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("endEditing"), object: nil)
            }
        }
    }
    
    func beginEditingAt(_ point: CGPoint, homeVC: ViewController) {
        if isStartInSrollView(point: point) {
            let offsetX = homeVC.scrollView.contentOffset.x
            let pageIndex = getPageIndexWithOffsetX(offsetX)
            NotificationCenter.default.post(name: "", object: <#T##Any?#>)
        } else {
            
        }
    }
    
    
    private func isStartInSrollView(point: CGPoint) -> Bool {
        return point.y < kScreenH - adapter(120)
    }
    
    private func getPageIndexWithOffsetX(_ offsetX: CGFloat) -> Int {
        return Int(offsetX/kScreenW)
    }
}


extension NSNotification.Name {
    static let
}
