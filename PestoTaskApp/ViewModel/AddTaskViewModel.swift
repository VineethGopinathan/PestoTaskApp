//
//  AddTaskViewModel.swift
//  PestoTaskApp
//
//  Created by Vineeth Gopinathan on 06/07/24.
//

import UIKit
import Combine

class AddTaskViewModel: ObservableObject {

    //MARK - Variables
    var databaseManager : DatabaseManager?
    
    init(manager: DatabaseManager = DatabaseManager()) {
         self.databaseManager = manager
    }
    
    
    //MARK: - Functions
    
    func addTask(task: Task, completion: @escaping AddTaskCompletionHandler){
         
        self.databaseManager?.addTask(task: task, completion: { success, error in
            completion(success,nil)
        })
            
    }
    
    //Update Task
    func updateTask(task: Task, completion: @escaping AddTaskCompletionHandler){
        self.databaseManager?.updateTask(task: task, completion: { success, error in
            completion(success, nil)
        })
    }
    
    //Delete Task
    func deleteTask(task: Task, completion: @escaping AddTaskCompletionHandler) {
        self.databaseManager?.deleteTask(task: task, completion: { success, error in
            completion(success, nil)
        })
    }
    
    
}
