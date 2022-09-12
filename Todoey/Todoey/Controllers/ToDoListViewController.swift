//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var tasks : Results<Item>?
    var addItemAlert : UIAlertController?
    let realm = try! Realm()
    
    //let defaults = UserDefaults.standard
   // let dataBaseFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentData.viewContext
    
    var currentCategory : Category? {
        didSet {
            loadData()
        }
    }
    
    
    //MARK: - UI Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.deletionActionDelegate = self
        let addTaskBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))
        addTaskBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = addTaskBarButton
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.showsCancelButton = true
        tableView.rowHeight = 80.0
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let colour = UIColor(hexString: currentCategory!.colour!)
        searchBar.barTintColor = colour
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        title = currentCategory?.name
        navigationController?.navigationBar.standardAppearance.backgroundColor = colour
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = colour
        navigationController?.navigationBar.standardAppearance.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    @objc func addTaskTapped(){
        let alert = UIAlertController(title: "Add a new task", message: "write a new task to add it to the to-do list", preferredStyle: .alert)
        alert.addTextField(){ [weak self] textField in
            textField.placeholder = "Add a task"
            textField.returnKeyType = .done
            textField.delegate = self
        }
        let submit = UIAlertAction(title: "Add Item", style: .default , handler: addItemButtonTapped(action:))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(submit)
        addItemAlert = alert
        present(alert, animated: true)
    }

    func addItemButtonTapped(action : UIAlertAction? = nil){
        guard let text = addItemAlert?.textFields?[0].text , !text.isEmpty else {return}
        let newTask = Item()
        newTask.title = text
        newTask.isDone = false
        save(item: newTask)
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func checkIfTaskDone(currentCell : UITableViewCell , indexPath : IndexPath){
        guard let currentTask = tasks?[indexPath.row] else {return}
        currentCell.accessoryType = currentTask.isDone ? .checkmark : .none
    }
    
    //MARK: - Table View data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = tasks?[indexPath.row]{
            cell.textLabel?.text = item.title
            let percentage = CGFloat(indexPath.row) / CGFloat(tasks!.count)
            let currentCategoryColour = UIColor(hexString: (currentCategory?.colour)!)
            if let colour = currentCategoryColour?.darken(byPercentage: percentage){
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                cell.backgroundColor = colour
            }
        }
        checkIfTaskDone(currentCell: cell, indexPath: indexPath)
        return cell
    }

    //MARK: - Table View delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)!
        updateItem(indexPath: indexPath)
        checkIfTaskDone(currentCell: currentCell, indexPath: indexPath)

        // to delete items in the intermediate context in core data
//        context.delete(tasks[indexPath.row])
//        tasks.remove(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//MARK: - Text Field delegate
extension ToDoListViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addItemButtonTapped()
        return true
    }
}

//MARK: - Search Bar delegate
extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        searchBar.resignFirstResponder()
        
        tasks = tasks?.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "dateCreated" ,ascending: true)
        tableView.reloadData()
        
//        let request = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadData(with: request, predicate: predicate)
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        loadData()
    }
}

//MARK: - User Defaults 
/*
extension ToDoListViewController {
    func saveData(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks){
            defaults.set(encoded, forKey: "Tasks")
        }
    }
    func loadData(){
        if let data = defaults.value(forKey: "Tasks") as? Data {
            let decoder = JSONDecoder()
            if let dataDecoded = try? decoder.decode([TaskModel].self, from: data){
                tasks = dataDecoded
            }
        }
    }
}
*/

//MARK: - Core Data
/*
extension ToDoListViewController {
    func saveData(){
        do {
            try context.save()
        }catch {
            fatalError("error saving context : \(error.localizedDescription)")
        }
    }
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", currentCategory!.name!)
        if let predicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
        }else {
            request.predicate = categoryPredicate
        }       
        do {
            tasks = try context.fetch(request)
        } catch {
            print("error saving context : \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}*/

//MARK: - Realm DataBase

extension ToDoListViewController {
    func save(item : Item){
        do {
            try realm.write {
                currentCategory?.items.append(item)
            }
        }catch {
            print("Error save a new Item to realm database")
        }
    }
    
    func loadData(){
        tasks = currentCategory?.items.sorted(byKeyPath: "title" ,ascending: true)
        tableView.reloadData()
    }
    
    func updateItem(indexPath : IndexPath){
        if let task = tasks?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(task)   to delete item in dataBase
                    task.isDone = !task.isDone
                }
            }catch {
                print("can't update item")
            }
            tableView.reloadData()
        }
    }
    func deleteItem(item : Item){
        do {
            try realm.write {
                realm.delete(item)
            }
        }catch {
            print("can't delete item")
        }
    }
}

//MARK: - Swappable Delegte

extension ToDoListViewController : SwappableDelegate {
    func deleteAction(indexPath: IndexPath) {
        if let task = tasks?[indexPath.row]{
            deleteItem(item: task)
        }
    }
    
}
