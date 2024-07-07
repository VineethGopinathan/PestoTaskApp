//
//  Constants.swift
//  PestoTaskApp
//
//  Created by Vineeth Gopinathan on 06/07/24.
//

import Foundation

typealias DatabaseCompletionHandler = (_ data: [AnyObject]?, _ error: NSError?) -> Void
typealias AddTaskCompletionHandler = (_ success: Bool?, _ error: NSError?) -> Void

struct Constants {
    
    //Storyboard Identifiers
    struct Storyboards {
        static let MAIN = "Main"
    }
    
    //Database
    
    struct Database {
        static let TASK_TABLE_NAME = "Task"
        
        
    }
    //TableView IDs
    struct TableView {
        static var TaskListTableViewCell = "TaskListTableViewCell"
    }
    
    //ViewController IDs
    struct ViewController {
        static var TasksViewController = "TasksViewController"
        static var AddTaskViewController = "AddTaskViewController"
    }
}
