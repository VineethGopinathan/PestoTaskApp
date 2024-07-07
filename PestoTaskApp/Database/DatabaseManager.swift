//
//  DatabaseManager.swift
//  PestoTaskApp
//
//  Created by Vineeth Gopinathan on 06/07/24.
//

import UIKit
import FirebaseDatabase
import FirebaseDatabaseSwift

class DatabaseManager  {
    
    // singleton shared object
    static let shared = DatabaseManager()
    
    //This is the database reference object to the firebase database
    let database = Database.database().reference()
    
    //MARK: - For getting all tasks from database
    func getAllTasks(completion: @escaping DatabaseCompletionHandler){
        
        database.child(Constants.Database.TASK_TABLE_NAME).observe(.value) { snapshot,arg  in
             
             guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                 return
             }
             
            
             let result = children.compactMap { snapshot in
                 
                 return try! snapshot.data(as: Task.self)
             }
            
             completion(result as [Task],nil)
         }
        
    }
    
    //MARK: - Get Tasks by status
    func getAllTasksByStatus(status: String, completion: @escaping DatabaseCompletionHandler) {
       
     let query = database.child(Constants.Database.TASK_TABLE_NAME).queryOrdered(byChild: "status").queryEqual(toValue: status)
        
       print(query)
        
        query.observe(.value) { snapshot in
            
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            let result = children.compactMap { snapshot in
                
                return try! snapshot.data(as: Task.self)
            }
           
            completion(result as [Task],nil)
        }
    
    }
    
    //MARK: - Add Task
    func addTask(task: Task, completion: @escaping AddTaskCompletionHandler) {
               
           guard database.child(Constants.Database.TASK_TABLE_NAME).childByAutoId().key != nil else {
                return
            }
          
            do {
                try database.child("\(Constants.Database.TASK_TABLE_NAME)/\(String(describing: task.id!))")
                    .setValue(from: task)
            } catch let error {
                print(error.localizedDescription)
            }
        
        
        completion(true, nil)
    
    }
    
    //MARK - Update Task
    func updateTask(task: Task, completion: @escaping AddTaskCompletionHandler) {
        database.child("\(Constants.Database.TASK_TABLE_NAME)/\(String(describing: task.id!))").updateChildValues(["title":task.title!,
                                            "description":task.description!,
                                            "status":task.status!])
        completion(true, nil)
    }
    
    //MARK: - Delete Task
    func deleteTask(task: Task, completion: @escaping AddTaskCompletionHandler) {
        database.child("\(Constants.Database.TASK_TABLE_NAME)/\(String(describing: task.id!))").setValue(nil)
        completion(true, nil)
    }
    

}
