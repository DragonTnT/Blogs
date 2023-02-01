//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Allen long on 2022/12/21.
//

import UIKit
import KDEAudioPlayer

class ViewController: UIViewController {
    
    lazy var playBtn: UIButton = {
        let it = UIButton()
        it.setTitle("播放", for: .normal)
        it.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        return it
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(playBtn)
        playBtn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    }

    @objc private func playAction() {
        let player = AudioPlayer()
        player.delegate = self
        let url = URL(string: "http://m8.music.126.net/20221221150034/1ae4ed480c4fd4c66dfd8d5630996c06/ymusic/c48c/fb99/1950/a0634034446f904929e37dc2686ba91b.mp3")
        let item = AudioItem(
            mediumQualitySoundURL: url)!
        player.play(item: item)
    }
}

extension ViewController: AudioPlayerDelegate {
    
}

