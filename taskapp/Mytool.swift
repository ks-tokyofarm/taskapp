//
//  Mytool.swift
//  taskapp
//
//  Created by 中川Air利光 on 2021/02/08.
//

import UIKit
import Foundation

var alertController: UIAlertController!


func alert(title:String, errmsg:String){
    alertController = UIAlertController(title: title, message: errmsg, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true)
    
}
