//
//  tracker.swift
//  IFTracker
//
//  Created by チャン　トゥハン on 2021/09/13.
//

import RealmSwift

class Tracker: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    //IF開始時間
    @objc dynamic var startTime = Date()
    //IF終了時間
    @objc dynamic var stopTime = Date()
    //実際IF時間
    @objc dynamic var elapsedTime = 0.0
    //設定したIF時間
    @objc dynamic var goalTime = 0.0
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}

class User : Object {
    @objc dynamic var id = 0
    @objc dynamic var nickname = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
