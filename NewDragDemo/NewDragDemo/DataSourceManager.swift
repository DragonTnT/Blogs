//
//  DataSourceManager.swift
//  DragDemo
//
//  Created by Allen long on 2022/5/16.
//

import Foundation
import HandyJSON


class DataSourceManager {
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveInDisk), name: UIApplication.willTerminateNotification, object: nil)
    }
    static let main = DataSourceManager()
    let mainKey = "home_main_items"
    let bottomKey = "home_bottom_items"
    
    var mainDataSource: [[HomeItem]] = []
    
    var bottomDataSource: [HomeItem] = []
        
    func fetchFromDisk() {
        fetchMainFromDisk()
        fetchBottomFromDisk()
    }
    
    @objc func saveInDisk() {
        saveMainToDisk()
        saveBottomToDisk()
    }
    
    private func fetchMainFromDisk() {
        if let dataSourceData = UserDefaults.standard.value(forKey: mainKey) as? Data {
                guard let dataSourceJson = try? JSONSerialization.jsonObject(with: dataSourceData, options: []) as? [[[String: Any]]]
            else { return }
            var dataSource: [[HomeItem]] = []
            for sectionJson in dataSourceJson {
                var sectionDataSource: [HomeItem] = []
                for json in sectionJson {
                    if let item = HomeItem.deserialize(from: json) {
                        sectionDataSource.append(item)
                    }
                }
                dataSource.append(sectionDataSource)
            }
            mainDataSource = dataSource
        } else {
            mainDataSource = defaultMainItems
            saveMainToDisk()
        }
    }
    
    private func fetchBottomFromDisk() {
        if let dataSourceData = UserDefaults.standard.value(forKey: bottomKey) as? Data {
                guard let dataSourceJson = try? JSONSerialization.jsonObject(with: dataSourceData, options: []) as? [[String: Any]]
            else { return }
            var dataSource: [HomeItem] = []
            for json in dataSourceJson {
                if let item = HomeItem.deserialize(from: json) {
                    dataSource.append(item)
                }
            }
            bottomDataSource = dataSource
        } else {
            bottomDataSource = defaultBottomItems
            saveBottomToDisk()
        }
    }
    
    private func saveMainToDisk() {
        var dataSource: [[[String: Any]]] = []
        for section in mainDataSource {
            var jsonArr: [[String: Any]] = []
            for item in section {
                if let json = item.toJSON() {
                    jsonArr.append(json)
                }
            }
            dataSource.append(jsonArr)
        }
        if let dataSourceData = try? JSONSerialization.data(withJSONObject: dataSource, options: []) {
            UserDefaults.standard.set(dataSourceData, forKey: mainKey)
        }
    }
    
    private func saveBottomToDisk() {
        var dataSource: [[String: Any]] = []
        for item in bottomDataSource {
            if let json = item.toJSON() {
                dataSource.append(json)
            }
        }
        if let dataSourceData = try? JSONSerialization.data(withJSONObject: dataSource, options: []) {
            UserDefaults.standard.set(dataSourceData, forKey: bottomKey)
        }
    }
}

let defaultMainItems: [[HomeItem]] = [
    [
        HomeItem(title: "QQ", indexPath: IndexPath(item: 0, section: 0)),
        HomeItem(title: "微信", indexPath: IndexPath(item: 1, section: 0)),
        HomeItem(title: "支付宝", indexPath: IndexPath(item: 2, section: 0)),
        HomeItem(title: "淘宝", indexPath: IndexPath(item: 3, section: 0)),
    ],
    [
        HomeItem(title: "追书神器", indexPath: IndexPath(item: 4, section: 0)),
        HomeItem(title: "微博", indexPath: IndexPath(item: 5, section: 0)),
        HomeItem(title: "百度", indexPath: IndexPath(item: 6, section: 0)),
        HomeItem(title: "QQ音乐", indexPath: IndexPath(item: 7, section: 0)),
        HomeItem(title: "网易云音乐", indexPath: IndexPath(item: 8, section: 0)),
        HomeItem(title: "哔哩哔哩", indexPath: IndexPath(item: 9, section: 0)),
        HomeItem(title: "皮皮虾", indexPath: IndexPath(item: 10, section: 0)),
        HomeItem(title: "美团", indexPath: IndexPath(item: 11, section: 0)),
    ]
]

let defaultBottomItems: [HomeItem] = [
    HomeItem(title: "snapChat", indexPath: IndexPath(item: 0, section: 0)),
    HomeItem(title: "facebook", indexPath: IndexPath(item: 1, section: 0)),
    HomeItem(title: "google", indexPath: IndexPath(item: 2, section: 0)),
]


class HomeItem: HandyJSON {
    
    required init() {}
    
    var title: String = ""
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    var isHidden = false
    var isEditing = false
    
    init(title: String, indexPath: IndexPath, isHidden: Bool = false) {
        self.title = title
        self.indexPath = indexPath
        self.isHidden = isHidden
    }
}
