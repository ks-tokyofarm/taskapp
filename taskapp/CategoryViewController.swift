//
//  CategoryViewController.swift
//  taskapp
//
//  Created by 中川Air利光 on 2021/02/08.
//

import UIKit
import RealmSwift           // 追加
import UserNotifications    // 追加

class CategoryViewController: UIViewController {
    @IBOutlet weak var cateName: UITextField!
 
    let realm = try! Realm()    // 追加
    var task: Task!         // 追加
    var cate: Cate!         // 追加
    var cate_tbl: Results<Cate>?
    var cate_no = 0
    var cate_qty = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cate_tbl = realm.objects(Cate.self)
        cate_qty = cate_tbl?.count ?? 0
        //        cateName.text = cate.name
        
        // Do any additional setup after loading the view.
    }
    
    // 登録するボタン処理
    @IBAction func CateEntry(_ sender: Any) {

        try! realm.write {
            self.cate.name = self.cateName.text!
            self.realm.add(self.cate, update: .modified)
        }
    }
    // キャンセルボタン処理
    @IBAction func cateCancel(_ sender: UIButton) {

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
