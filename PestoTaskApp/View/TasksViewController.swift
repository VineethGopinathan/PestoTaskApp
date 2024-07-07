//
//  ViewController.swift
//  PestoTaskApp
//
//  Created by Vineeth Gopinathan on 05/07/24.
//

import UIKit
import Combine

class TasksViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var buttonAddTask: UIButton!
    
    @IBOutlet weak var tableViewTasks: UITableView!
    
    @IBOutlet weak var popupButtonStatus: UIButton!
    
    //MARK: - Variables
    
    lazy var taskListViewModel: TaskListViewModel = {
        let viewModel = TaskListViewModel()
        return viewModel
    }()
        
    private var cancellables: Set<AnyCancellable> = []
    var taskList = [Task]()
    var selectedStatus = String()
    var noDataLabel = UILabel()
    var menuElements = [UIMenuElement]()
    var statusNameList = ["All", "To Do", "In Progress", "Done"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
       // getTasks()
        bindViewModel()
        setupPopupButton()
       
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedStatus = popupButtonStatus.currentTitle ?? ""
        if selectedStatus == "All" {
            //Fetch all tasks
            getTasks()
        } else {
            
        }
    }

    //MARK: - Functions
    // Configure Views
    
    func configureView() {
        tableViewTasks.register(UINib(nibName: Constants.TableView.TaskListTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.TableView.TaskListTableViewCell)
    }
    
    //Bind View Model with View Controller
    private func bindViewModel(){
        taskListViewModel.$tasks.sink { taskList in
            print(taskList)
            self.taskList.removeAll()
            for task in taskList {
                self.taskList.append(task)
            }
            
            self.tableViewTasks.reloadData()
        }.store(in: &cancellables)
    }
    
    //Set the Status of Tasks
    func setupPopupButton(){
        //Load users from User table
        let optionClosure = {(action: UIAction) in
            print("Item Selected : \(action.title)")
            if action.title == "All" {
                self.getTasks()
            } else {
                
                self.taskListViewModel.getTasksByStatus(status: action.title)
                /*self.taskListViewModel.filterTasks(filterBy: "created_user_id", filterValue: action.title) { status, message, data, error in
                    print("Filter by user completed")
                }*/
            }
          
        }
        
        //menuElements.append(UIAction(title: "All users", handler: optionClosure))
        for status in statusNameList {
            menuElements.append( UIAction(title: status, handler: optionClosure))
        }
        popupButtonStatus.menu = UIMenu(children: menuElements)
        popupButtonStatus.showsMenuAsPrimaryAction = true
        popupButtonStatus.changesSelectionAsPrimaryAction = true
        
       
        
        
    }
    
    //Get all tasks
    func getTasks(){
        taskListViewModel.getAllTasks()
    }
    //MARK: - IBActions
    
    @IBAction func buttonActionAddTask(_ sender: UIButton) {
        let addTaskViewController = UIStoryboard.init(name: Constants.Storyboards.MAIN, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewController.AddTaskViewController) as! AddTaskViewController
        addTaskViewController.updateFlag = false
        addTaskViewController.taskCount = taskList.count
        self.navigationController?.pushViewController(addTaskViewController, animated: true)
        
    }
    
}

//MARK: - TableView Delegate
extension TasksViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

//MARK: - TableView Datasource

extension TasksViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if taskList.count == 0 {
            noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                    noDataLabel.text          = "No active tasks."
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    tableView.backgroundView  = noDataLabel
                    tableView.separatorStyle  = .none
            noDataLabel.isHidden = false
        } else {
            noDataLabel.isHidden = true
            tableView.backgroundView  = nil
        }
        return taskList.count
        
        
       // return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.TaskListTableViewCell, for: indexPath) as! TaskListTableViewCell
        let task = taskList[indexPath.row]
        cell.loadTask(task: task)
        cell.delegate = self
        return cell
    }
    
    
}

//MARK: - TaskListCellDelegate
extension TasksViewController: TaskListCellDelegate {
    
    func deleteTask(task: Task) {
        
        //Showing an alert before delete
        let alertController = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
               
               // Create OK button
               let OKAction = UIAlertAction(title: "Delete", style: .default) { (action:UIAlertAction!) in
                   
                   self.taskListViewModel.deleteTask(task: task) { data, error in
                       if error == nil {
                           print("Task Deleted")
                           self.getTasks()
                           self.tableViewTasks.reloadData()
                       } else {
                           print("Task Delete Failed")
                       }
                   }
            
               }
               alertController.addAction(OKAction)
               
               // Create Cancel button
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                   print("Cancel button tapped");
               }
               alertController.addAction(cancelAction)
               
               // Present Dialog message
               self.present(alertController, animated: true, completion:nil)
        
        
    }
    
    func updateTask(task: Task) {
        let addTaskViewController = UIStoryboard.init(name: Constants.Storyboards.MAIN, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewController.AddTaskViewController) as! AddTaskViewController
        addTaskViewController.updateFlag = true
        addTaskViewController.task = task
        self.navigationController?.pushViewController(addTaskViewController, animated: true)
        
    }
    
    
}
