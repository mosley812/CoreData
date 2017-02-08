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
  
  // MARK: -
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textField: UITextField!
  @IBAction func addButtonTapped(_ sender: UIButton) {
    save(name: textField.text!)
  }
  
  // MARK: - Fetched Result Controller
  fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ToDo> = {

    // Create the fetch request
    let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
    
    // Configure Fetch Request
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    // Create Fetched Results Controller
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: CoreDataController.getContext(),
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    // Configure Fetched Results Controller
    fetchedResultsController.delegate = self
    
    return fetchedResultsController

  }()
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
    // Populate the tableView
    do {
      try self.fetchedResultsController.performFetch()
    } catch {
      fatalError("Failed to initialize FetchedResultsController: \(error)")
    }
    
  }
  
  // MARK: -
  func save(name: String) {
    let toDo: ToDo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: CoreDataController.getContext()) as! ToDo
    toDo.name = name
    CoreDataController.saveContext()
    
    // Pop View Controller
    _ = navigationController?.popViewController(animated: true)
  }
  
}

// MARK: -
extension ViewController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .insert:
      if let indexPath = newIndexPath {
        tableView.insertRows(at: [indexPath], with: .fade)
      }
      break;
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
      break;
    default:
      print("...")
      
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    
  }
  
  
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let toDos = fetchedResultsController.fetchedObjects else { return 0 }
    return toDos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    // fetch to do
    let toDo = fetchedResultsController.object(at: indexPath)
    
    // Update Cell
    cell.textLabel?.text = toDo.name

    //Populate the cell from the object
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Fetch Quote
      let toDo = fetchedResultsController.object(at: indexPath)
      
      // Delete Quote
      toDo.managedObjectContext?.delete(toDo)
    }
  }
  
}
