//
//  ViewController.swift
//  StackViewDemo
//
//  Created by Allen long on 2021/5/6.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let stack: UIStackView = {
        let it = UIStackView()
        it.backgroundColor = .white
        it.backgroundColor = .gray
        return it
    }()
    
    let sub1: PaddingLabel = {
        let it = PaddingLabel(leftPadding: 15)
        it.text = "5座"
        return it
    }()
    
    let sub2: PaddingLabel = {
        let it = PaddingLabel(leftPadding: 15)
        it.text = "轿车"
        return it
    }()
    
    let sub3: PaddingLabel = {
        let it = PaddingLabel(leftPadding: 15)
        it.text = "4年1月"
        return it
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(100)
            $0.trailing.equalTo(0)
            $0.height.equalTo(50)
        }
        stack.addArrangedSubview(sub1)
        stack.addArrangedSubview(sub2)
        stack.addArrangedSubview(sub3)
                    
    }

    @IBAction func action1(_ sender: Any) {
        sub3.isHidden = true
        print(sub1.subviews)
    }
    @IBAction func action2(_ sender: Any) {
        sub2.isHidden = true
        print(stack.arrangedSubviews)
    }
    
}


