//
//  ViewController.swift
//  taskapp
//
//  Created by 中川Air利光 on 2021/01/29.
//

import UIKit
import RealmSwift   // 追加

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchStr: UISearchBar!
    
    // Realmインスタンスを取得する
    let realm = try! Realm()    // 追加
    
    var count = 0
    
    // DB内のタスクが格納されるリスト。
    // 日付の近い順でソート：昇順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)  // 追加
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchStr.delegate = self   // SearchBarのデリゲート先を自分に設定
//        searchStr.showsCancelButton = true  // 中断ボタン表示
        searchStr.enablesReturnKeyAutomatically = false     // 未入力でもReturnキーを押せるようにする(全件表示対応)
    }

    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count  // 修正
    }

    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Cellに値を設定する.  --- ここから ---
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        // --- ここまで ---
        /*
        if (indexPath.row % 2) == 0 {
            cell.backgroundColor = UIColor.lightGray    // セル背景をライトグレーに
        }
        else {
            cell.backgroundColor = UIColor.white        // セル背景をホワイトに
        }
        */
        
        return cell
    }

    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)   // ＋ボタンとセルのタップで画面遷移
    }

    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // --- ここから ---
        if editingStyle == .delete {
            // 削除するタスクを取得する
            let task = self.taskArray[indexPath.row]
            
            // ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            // 未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("/---------------")
                }
            }
        // --- ここまで ---
        }
    }

    // 検索バー編集開始時処理
    func searchBarTextDidBeginEditing(_ searchStr: UISearchBar){
        searchStr.becomeFirstResponder()
        searchStr.setShowsCancelButton(true, animated: true)
    }
    // 検索ボタン(Enter)が押された時の処理
    func searchBarSearchButtonClicked(_ searchStr: UISearchBar) {
        let searchText = searchStr.text!    // 入力文字列を代入
        searchStr.resignFirstResponder()
        searchStr.setShowsCancelButton(false, animated: true)
        if searchText != "" {   // カテゴリの入力あった？
            taskArray = try! Realm().objects(Task.self).filter("category == '\(searchText)'").sorted(byKeyPath: "date", ascending: true)    // 入力カテゴリでフィルタ
            tableView.reloadData()
        }
        else {  // カテゴリが入力されていない？
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)  //全て表示
            tableView.reloadData()
        }
    }
    // 検索時のキャンセルボタンが押された時の処理
    func searchBarCancelButtonClicked(_ searchStr: UISearchBar){
        if searchStr.text != "" {
            searchStr.text = ""
        }
        searchStr.resignFirstResponder()
        searchStr.setShowsCancelButton(false, animated: true)
    }
    
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        }
        else {
            let task = Task()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}

