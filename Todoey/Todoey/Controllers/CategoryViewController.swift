//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andrew Emad on 06/09/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    var categories : Results<Category>?
    var addItemAlert : UIAlertController?
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentData.viewContext
    let realm = try! Realm()
    //let dataBasePath = Realm.Configuration.defaultConfiguration.fileURL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.deletionActionDelegate = self
       // print(dataBasePath)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let addTaskBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategoryTapped))
        addTaskBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = addTaskBarButton
        tableView.rowHeight = 80.0
        navigationController?.navigationBar.standardAppearance.backgroundColor = .cyan
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .cyan
        navigationController?.navigationBar.standardAppearance.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor:UIColor.white]
    }

    //MARK: - UI Methods
    
    @objc func addCategoryTapped(){
        let alert = UIAlertController(title: "Add a new Category", message: "write a new category to add it to the to-do list", preferredStyle: .alert)
        alert.addTextField(){ [weak self] textField in
            textField.placeholder = "Add a Category"
            textField.returnKeyType = .done
            textField.delegate = self
        }
        let submit = UIAlertAction(title: "Add Category", style: .default , handler: addCategoryButtonTapped(action:))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(submit)
        addItemAlert = alert
        present(alert, animated: true)
    }
    
    func addCategoryButtonTapped(action : UIAlertAction? = nil){
        guard let text = addItemAlert?.textFields?[0].text , !text.isEmpty else {return}
        let category = Category()
        category.name = text
        category.colour = UIColor.randomFlat().hexValue()
        save(category: category)
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let currentCategory = categories?[indexPath.row]{
            cell.textLabel?.text = currentCategory.name
            if let colourHex = currentCategory.colour {
                cell.backgroundColor = UIColor(hexString: colourHex)
            }
        }  
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToTasks", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToTasks" {
            let vc = segue.destination as? ToDoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc?.currentCategory = categories?[indexPath.row]
            }
        }
    }
}

//MARK: - Text Field Delegate

extension CategoryViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addCategoryButtonTapped()
        return true
    }
}

//MARK: - Core Data
/*
extension CategoryViewController {
    
    func saveData(){
        do {
            try context.save()
        } catch {
            fatalError("error saving context : \(error.localizedDescription)")
        }
    }
    
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categories = try context.fetch(request)
        } catch {
            fatalError("error saving context : \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}*/

//MARK: -  Realm DataBase

extension CategoryViewController {
    
    func save(category : Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error save a new Category to realm database")
        }
        
    }
    
    func loadData(){
        categories = realm.objects(Category.self)
    }
    func delete(category : Category){
        do {
            try realm.write {
                for item in category.items {
                    realm.delete(item)
                }
                realm.delete(category)
            }
        } catch {
            print("Error delete a category")
        }
    }
}

//MARK: - Swappable Delegate
extension CategoryViewController : SwappableDelegate {
    func deleteAction(indexPath: IndexPath) {
        if let category = categories?[indexPath.row]{
            delete(category: category)
        }
    }
    
}
