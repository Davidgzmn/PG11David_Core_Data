//
//  ViewController.swift
//  PG11David_Core_Data
//
//  Created by David Guzman on 2017-10-07.
//  Copyright © 2017 David Guzman. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
//Declare mi IBOutlets
    @IBOutlet weak var todoTableView: UITableView!
    @IBAction func goToAdd(_ sender: Any) {
        performSegue(withIdentifier: "segueToAddNote", sender: self)
    }
//Create an array of my entities ToDo
    var myToDoTasks = [ToDo]()


    //Runs when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register my custom cell
        todoTableView.register(UINib(nibName:"CustomToDoCell", bundle:nil), forCellReuseIdentifier: "toDoCell")

    }
    override func viewDidAppear(_ animated: Bool) {
        todoTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        //Set the table view's delegate and data source
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        //Get app delegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        //Get the context
        let context = delegate.persistentContainer.viewContext
        //Create the fetch request
        let fetchRequest = NSFetchRequest<ToDo>(entityName: "ToDo")
        //Reload the table view
        todoTableView.reloadData()
        do
        {
            //Fill my array with the entities in the core data
            myToDoTasks = try context.fetch(fetchRequest)
        
        }
        catch let error as NSError
        {
            print("Could not save. \(error),\(error.userInfo)")
        }
        
    }
}

//Extend my view controller for the data source of a table view
extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue my custom cell
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as! CustomToDoCell
        //Fill the cells labels with the appropiate text
        cell.nameLabel?.text = myToDoTasks[indexPath.row].name
        cell.notesLabel?.text = myToDoTasks[indexPath.row].notes
        //If its complete, text is green, else its yellow. Background is black
        let task = myToDoTasks[indexPath.row]
        if task.isComplete{
            cell.nameLabel?.textColor = UIColor.green
            cell.notesLabel?.textColor = UIColor.green
            cell.backgroundColor = UIColor.black
            
        }
        else{
            cell.nameLabel?.textColor = UIColor.yellow
            cell.notesLabel?.textColor = UIColor.yellow
            cell.backgroundColor = UIColor.black
        }
        //Return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myToDoTasks.count
    }
    //Attempt to send toDo object to edit view, failed
//now it just sends text, but can ve changed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? editNoteViewController{
            //if let indexPath = todoTableView.indexPathForSelectedRow{
                //let toDo = myToDoTasks[indexPath.row]
                //destination.toDoTask = toDo
                
                //destination.taskTitle = toDo.name!
                //destination.taskNotes = toDo.notes!
                destination.taskTitle = "Title"
                destination.taskNotes = "Details"
                //destination.taskIsComplete = toDo.isComplete
                
                
                
            }
        //}
    }
    
    //Code for deletion
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else{
                return
            }
            let context = delegate.persistentContainer.viewContext

            let task = myToDoTasks[indexPath.row]
            
            let index = myToDoTasks.index(of: task)
            if let index = index {
                myToDoTasks.remove(at: index)
                context.delete(task)
                try? context.save()
                todoTableView.reloadData()
            }
        }
        
    }
    
    
    
}

//Extension for delegates

extension ViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Guard the getting of the delegate
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        //Get cotext and, if clicked, the rows isComplete attribute is inverted, then save
        let context = delegate.persistentContainer.viewContext
        myToDoTasks[indexPath.row].isComplete = !myToDoTasks[indexPath.row].isComplete
        try? context.save()
        //Reload table view
        todoTableView.reloadData()
        //When clicked, cells send you to a edit view controller
        performSegue(withIdentifier: "segueToEditView", sender: self)
        
    }


}
 
