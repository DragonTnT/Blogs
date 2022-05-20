//
//  MessViewController.swift
//  NewDragDemo
//
//  Created by Allen long on 2022/5/19.
//

import UIKit

class MessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        let label = UILabel()
        label.text = "消息页面"
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }
    

}
