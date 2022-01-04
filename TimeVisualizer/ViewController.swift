//
//  ViewController.swift
//  TimeVisualizer
//
//  Created by A Ab. on 30/05/1443 AH.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var progressBut: UIBarButtonItem!
    
    
    //save data core data
    var events = [EventEntity]()
    private var createdTimeEvent: EventEntity?
   
    var events2 : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        fetchItems()
    
    }
    
    
    @IBAction func addButPressed(_ sender: UIButton) {
        guard let sentence = userInput.text else { return  }
        let newItemEntity = EventEntity(context: managedObjectContext)
        newItemEntity.event = sentence
        events.append(newItemEntity)
        events2.append(sentence)
        tableView.reloadData()
        saveContext()
    }
    
    @IBAction func progressButPressed(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GraphViewController") as! GraphicViewController
        vc.events = events
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func fetchItems(){
        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntity")
        do{
            let results = try managedObjectContext.fetch(itemRequest)
            events = results as! [EventEntity]
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    func saveContext(){
        do{
            try managedObjectContext.save()
        }catch {
            print(error)
        }
    }
    
    
    ////MARK: - Core Data Persistence
    
//    func getUpdatedContext()->NSManagedObjectContext{
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        return delegate.persistentContainer.viewContext
//    }
//
//    func saveContext(){
//        let context = getUpdatedContext()
//
//        do{
//            try context.save()
//        }catch{
//
//            print(error.localizedDescription)
//        }
//
//    }
//
//    //CRUD
//
//    //Create
//    func createTimeEvent(text: String) -> EventEntity{
//        let context = getUpdatedContext()
//        let timeEventEntity = EventEntity.init(context: context)
//        timeEventEntity.event = text
//
//
//        return timeEventEntity
//    }
//
//    //read
//    func getAllEvents() -> [EventEntity]{
//        let context = getUpdatedContext()
//        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntity")
//
//        do{
//            let results = try context.fetch(itemRequest)
//
//            let timeEvents = results as! [EventEntity]
//            self.timeEvents = timeEvents
//            return timeEvents
//        }catch{
//            print(error.localizedDescription)
//            return []
//        }
//    }


}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = events[indexPath.row].event
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
}

