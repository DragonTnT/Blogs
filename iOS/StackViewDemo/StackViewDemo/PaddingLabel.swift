//
//  PaddingLabel.swift
//  youchelai
//
//  Created by Allen long on 2020/2/27.
//  Copyright © 2020 utimes. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {

    let leftPadding: CGFloat
    let topPadding: CGFloat
    
    init(leftPadding: CGFloat = 0, topPadding: CGFloat = 0, frame: CGRect = .zero) {
        self.leftPadding = leftPadding
        self.topPadding = topPadding
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: topPadding, right: leftPadding)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 2 * leftPadding, height: size.height + 2 * topPadding)
    }

}
