//
//  editNoteViewController.swift
//  PG11David_Core_Data
//
//  Created by David Guzmán on 10/8/17.
//  Copyright © 2017 David Guzman. All rights reserved.
//

import UIKit
import CoreData

class editNoteViewController: UIViewController {
//Declare ToDo object to recieve and edit
    //Declare IBOutlets
    //var toDoTask = ToDo()
    var taskTitle = "Tasks Title"
    var taskNotes = "Tasks Details"
    var taskIsComplete:Bool = true
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    //Declare the action of the button
    @IBAction func saveChanges(_ sender: Any) {
        //Guard the getting of the delegate
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        //Get the context, create an entity for that context and set its values
        let context = delegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: context)!
        let ToDo = NSManagedObject(entity: entity, insertInto: context)
        
        ToDo.setValue(titleTextField.text, forKeyPath: "name")
        ToDo.setValue(notesTextField.text, forKeyPath: "notes")
        do
        {
            try context.save() //Save that context
        }
        catch let error as NSError //If there is an error, process it
        {
            print("Could not save. \(error),\(error.userInfo)")
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.placeholder = taskTitle
        notesTextField.placeholder = taskNotes

        // Do any additional setup after loading the view.
    }
}
