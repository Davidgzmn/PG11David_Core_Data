//
//  addNoteViewController.swift
//  PG11David_Core_Data
//
//  Created by David Guzmán on 10/8/17.
//  Copyright © 2017 David Guzman. All rights reserved.
//

import UIKit
import CoreData

class addNoteViewController: UIViewController {
//Declare IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    //Get delegate, context and create an entity
    @IBAction func saveToDo(_ sender: Any) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = delegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: context)!
        let ToDo = NSManagedObject(entity: entity, insertInto: context)
        //Set the entities attributes to the value on textfields
        ToDo.setValue(nameTextField.text, forKeyPath: "name")
        ToDo.setValue(detailTextField.text, forKeyPath: "notes")
        
        do
        {
                try context.save() //Save the context
        }
        catch let error as NSError //If theres an error, process it
        {
            print("Could not save. \(error),\(error.userInfo)")
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
