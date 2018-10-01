//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Felix-ITS 013 on 01/10/18.
//  Copyright © 2018 Felix013. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var names:[String] = []
    var people: [NSManagedObject] = []

    

    
    @IBOutlet var tabelview: UITableView!
    
    
    @IBAction func addName(_ sender: Any) {
      let alert = UIAlertController(title: "new Name", message: "Add New Item", preferredStyle:.alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.tabelview.reloadData()
        }

        let CancleAction = UIAlertAction(title: "Cancle", style: .cancel)
            alert.addTextField()
            alert.addAction(saveAction)
            alert.addAction(CancleAction)
            self.present(alert, animated: true)
          
                                        
                                        
            
            
                                        
                                
    }
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Person",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "the List"
        tabelview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - UITableViewDataSource
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
    // MARK: - UITableViewDataSource
    extension ViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView,
                       numberOfRowsInSection section: Int) -> Int {
            return people.count
        }
        
        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath)
            -> UITableViewCell {
                
                let person = people[indexPath.row]
                let cell =
                    tableView.dequeueReusableCell(withIdentifier: "cell",
                                                  for: indexPath)
                cell.textLabel?.text =
                    person.value(forKeyPath: "name") as? String
                return cell
        }
    }




