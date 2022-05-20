//
//  Helper.swift
//  DragDemo
//
//  Created by Allen long on 2022/5/7.
//

import Foundation
import UIKit

func adapter(_ value: CGFloat) -> CGFloat {
    return (value * (UIScreen.main.bounds.width/375)).rounded()
}


protocol NibLoadable {}
extension NibLoadable where Self: UIView {
    static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
}
