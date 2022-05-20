//
//  DragSortCollectionCell.swift
//  DemosInSwift
//
//  Created by 古创 on 2021/9/9.
//  Copyright © 2021 c. All rights reserved.
//

import UIKit

class DragSortCollectionCell: UICollectionViewCell,NibLoadable {
    
    var item: HomeItem! {
        didSet {
            if item.isEditing {
                startShake()
            } else {
                stopShake()
            }
        }
    }
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = adapter(15)
        bgView.layer.masksToBounds = true

    }
    
    func startShake() {
        
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        shakeAnimation.values = [-5 / 180 * Double.pi, 5 / 180 * Double.pi, -5 / 180 * Double.pi]
        shakeAnimation.isRemovedOnCompletion = false
        shakeAnimation.fillMode = .forwards
        shakeAnimation.duration = 0.3
        shakeAnimation.repeatCount = MAXFLOAT
        contentView.layer.add(shakeAnimation, forKey: "shake")
        
    }

    func stopShake() {
        contentView.layer.removeAnimation(forKey: "shake")
    }
}
