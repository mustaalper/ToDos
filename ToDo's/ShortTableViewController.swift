//
//  ShortTableViewController.swift
//  ToDo's
//
//  Created by MAA on 10.08.2022.
//

import UIKit
import CoreData

class ShortTableViewController: UIViewController {

    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    var toDoList = [ToDo]()
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getFilterToDo(filter: "Low")
        tableView.reloadData()
    }
    
    @IBAction func switchTVA(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
        print(selectedIndex)
        if selectedIndex == 0 {
            getFilterToDo(filter: "Low")
        } else if selectedIndex == 1 {
            getFilterToDo(filter: "Medium")
        } else if selectedIndex == 2 {
            getFilterToDo(filter: "High")
        }
        tableView.reloadData()
    }
    
    func getFilterToDo(filter: String) {
        do {
            let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
            
            let pred = NSPredicate(format: "picker CONTAINS '\(filter)'")
            request.predicate = pred
            
            toDoList = try context.fetch(request)
        } catch  {
            print(error)
        }
    }
}

extension ShortTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toDo = toDoList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoSegmentCell", for: indexPath) as! ShortTableViewCell
        
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
}
