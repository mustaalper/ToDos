//
//  TableViewController.swift
//  ToDo's
//
//  Created by MAA on 10.08.2022.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class TableViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet var tableView: UITableView!
    
    var toDoList = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllToDo()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        
        if segue.identifier == "toDetail" {
            let destVC = segue.destination as! ToDoDetailVC
            destVC.todo = toDoList[index!]
        }
    }
    
    func getAllToDo() {
        do {
            toDoList = try context.fetch(ToDo.fetchRequest())
        } catch  {
            print(error)
        }
    }
    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toDo = toDoList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCellID", for: indexPath) as! ToDoTableViewCell
        
        cell.titleLbl.text = "\(toDo.title!)"
        cell.descLbl.text = "\(toDo.desc!)"
        cell.prioLbl.text = "\(toDo.picker!)"
        
        let prioColor = "\(toDo.picker!)"
        
        if prioColor == "Low" {
            cell.prioLbl.textColor = .blue
        } else if prioColor == "Medium" {
            cell.prioLbl.textColor = .lightGray
        } else {
            cell.prioLbl.textColor = .red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { action, indexPath in
            let toDo = self.toDoList[indexPath.row]
            
            self.context.delete(toDo)
            
            appDelegate.saveContext()
            self.getAllToDo()
            self.tableView.reloadData()
        }
        
        let updateAction = UITableViewRowAction(style: .normal, title: "Edit") { action, indexPath in
            self.performSegue(withIdentifier: "toDetail", sender: indexPath.row)
        }
        
        deleteAction.backgroundColor = .red
        updateAction.backgroundColor = .gray
        return [deleteAction, updateAction]
    }
    
    
}
