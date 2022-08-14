//
//  ViewController.swift
//  ToDo's
//
//  Created by MAA on 10.08.2022.
//

import UIKit
import CoreData

class ToDoDetailVC: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet var titleTF: UITextField!
    @IBOutlet var descTF: UITextField!
    @IBOutlet var picker: UIPickerView!
    
    let priority = ["Low", "Medium", "High"]
    
    var prio = ""
    
    var todo: ToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        // Do any additional setup after loading the view.
        
        if let t = todo {
            titleTF.text = t.title
            descTF.text = t.desc
        }
    }


    @IBAction func saveAction(_ sender: Any) {
        
        if todo == nil {
            if let title = titleTF.text, let desc = descTF.text {
                let toDo = ToDo(context: context)
                toDo.title = title
                toDo.desc = desc
                if prio.isEmpty {
                    toDo.picker = "Low"
                } else {
                    toDo.picker = prio
                }
                
                appDelegate.saveContext()
            }
        } else {
            if let t = todo, let title = titleTF.text, let desc = descTF.text {
                t.title = title
                t.desc = desc
                if prio.isEmpty {
                    t.picker = "Low"
                } else {
                    t.picker = prio
                }
                
                appDelegate.saveContext()
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
}

extension ToDoDetailVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priority.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priority[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(priority[row])")
        self.prio = priority[row]
    }
}

