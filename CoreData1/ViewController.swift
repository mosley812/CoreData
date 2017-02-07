//
//  ViewController.swift
//  CoreData1
//
//  Created by Ed Mosher on 2/7/17.
//  Copyright © 2017 Ed Mosher. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  //var toDos: [NSManagedObject] = []
  var toDos = [NSManagedObject]()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    //insertData()
    //fetchData()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    //let fetchRequest: NSFetchRequest<ToDo> = NSFetchRequest(entityName: "ToDo")
    let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
    do {
      toDos = try CoreDataManager.getContext().fetch(fetchRequest)
    } catch {
      print("Could not fetch. \(error)")
      //print("Error: \(error)")
    }
    
    
  }
  
  // Insert the data (This was used to initially populate the data model)
  func insertData() {
    let toDo: ToDo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: CoreDataManager.getContext()) as! ToDo
    toDo.name = "To-do1"
    CoreDataManager.saveContext()
  }
  
  // Fetch the data (This was used to initially display the data)
  func fetchData() {
    let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
    do {
      let searchResults = try CoreDataManager.getContext().fetch(fetchRequest)
      print("Number of results: \(searchResults.count)")
      for result in searchResults {
        print("To-do: \(result.name)")
      }
    } catch {
      print("Error: \(error)")
    }
  }
  
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return toDos.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = toDos[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = item.value(forKeyPath: "name") as? String
    return cell
  }
}
