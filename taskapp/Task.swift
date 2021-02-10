//
//  Task.swift
//  taskapp
//
//  Created by 中川Air利光 on 2021/02/02.
//

import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var title = ""

    // カテゴリ選択番号
//    @objc dynamic var cate_no = 0 // カテゴリ番号
    @objc dynamic var category = "" // カテゴリ名
    
    // 内容
    @objc dynamic var contents = ""

    // 日時
    @objc dynamic var date = Date()
    
    // id をプライマリキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}

//カテゴリ情報クラス
class Cate: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    // cate_no をプライマリキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}


