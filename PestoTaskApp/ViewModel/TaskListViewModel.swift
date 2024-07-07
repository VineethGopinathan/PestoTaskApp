//
//  TaskListViewModel.swift
//  PestoTaskApp
//
//  Created by Vineeth Gopinathan on 06/07/24.
//

import UIKit
import Combine
import FirebaseDatabase
import FirebaseDatabaseSwift

class TaskListViewModel: ObservableObject {

    //MARK - Variables
    var databaseManager : DatabaseManager?
    @Published var tasks: [Task] = []
    
    init(manager: DatabaseManager = DatabaseManager()) {
         self.databaseManager = manager
    }
    
    
    //MARK: - Functions
    func connectDatabase(){
        
    }
    
    //Get All Tasks
    func getAllTasks(){
        self.databaseManager!.getAllTasks { data, error in
            let tasksList = data as! [Task]
            self.tasks = tasksList
        }
    }
    
    func getTasksByStatus(status: String){
        self.databaseManager?.getAllTasksByStatus(status: status, completion: { data, error in
            let tasksList = data as! [Task]
            self.tasks = tasksList
        })
    }
    //Delete Task
    func deleteTask(task: Task, completion: @escaping AddTaskCompletionHandler){
        self.databaseManager?.deleteTask(task: task, completion: { success, error in
            completion(success, error)
        })
    }
    
    
}
