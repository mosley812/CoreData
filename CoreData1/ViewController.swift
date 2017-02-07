//
//  ViewController.swift
//  CoreData1
//
//  Created by Ed Mosher on 2/7/17.
//  Copyright © 2017 Ed Mosher. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
  
  //var toDos: [NSManagedObject] = []
  var toDos = [NSManagedObject]()
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textField: UITextField!
  @IBAction func addButtonTapped(_ sender: UIButton) {
    //let nameToSave = textField.text
    //print(self)//<CoreData1.ViewController: 0x7fe421401e70>
    save(name: textField.text!)
  }
  
  //lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
  lazy var fetchedResultsController: NSFetchedResultsController<ToDo> = {
    
    let fetchRequest = NSFetchRequest<ToDo>(entityName: "ToDo")

    let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    let sortDescriptors = [primarySortDescriptor]
    
    fetchRequest.sortDescriptors = sortDescriptors
    
    let frc = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: CoreDataController.getContext(),
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    frc.delegate = self
    
    return frc
  }()
  
  
  
  //var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
/*
  func initializeFetchedResultsController() {
    // Initialize Fetch Request
    //let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
    let fetchRequest = NSFetchRequest<ToDo>(entityName: "ToDo")
    
    let moc = CoreDataController.getContext()
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    
  }
*/  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    //insertData()
    //fetchData()
    //print(self)// <CoreData1.ViewController: 0x7fe421401e70>
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      fatalError("Failed to initialize FetchedResultsController: \(error)")
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    /*
    //let fetchRequest: NSFetchRequest<ToDo> = NSFetchRequest(entityName: "ToDo")
    let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
    do {
      toDos = try CoreDataController().fetch(fetchRequest)
    } catch {
      print("Could not fetch. \(error)")
      //print("Error: \(error)")
    }
    */
    
  }
  
  func save(name: String) {
    let toDo: ToDo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: CoreDataController.getContext()) as! ToDo
    toDo.name = name
    CoreDataController.saveContext()
    
  }
  
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      let sectionInfo = sections[section]
      return sectionInfo.numberOfObjects
    }
    
    return 0
    //return toDos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    // Set up the cell
    let record = fetchedResultsController.object(at: indexPath)

    // Update Cell
    if let name = record.value(forKeyPath: "name") as? String {
      cell.textLabel?.text = name
    }
    
    //Populate the cell from the object
    return cell

  }
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let item = toDos[indexPath.row]
//    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//    cell.textLabel?.text = item.value(forKeyPath: "name") as? String
//    return cell
//  }
}
