//
//  AddTaskViewController.swift
//  PestoTaskApp
//
//  Created by Vineeth Gopinathan on 05/07/24.
//

import UIKit
import Combine

class AddTaskViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var labelAllTasks: UILabel!
    
    @IBOutlet weak var textViewTitle: UITextView!
    
    @IBOutlet weak var textViewDescription: UITextView!
    
    @IBOutlet weak var popupButtonStatus: UIButton!
    
    
    @IBOutlet weak var buttonAddTask: UIButton!
    
    
    //MARK: - Variables
    
    var addTaskViewModel: AddTaskViewModel {
        let viewModel = AddTaskViewModel()
        return viewModel
    }
    var task: Task!
    private var cancellables: Set<AnyCancellable> = []
    var updateFlag: Bool = false
    var taskCount: Int = 0
    var menuElements = [UIMenuElement]()
    var statusNameList = ["To Do", "In Progress", "Done"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        //bindViewModel()
        setupPopupButton()
        
    }
    
    func setupUI() {
        //Set TextView Delegates
        textViewTitle.delegate = self
        textViewDescription.delegate = self
        buttonAddTask.layer.cornerRadius = 10
        if updateFlag {
            labelAllTasks.text = "Edit Task"
            buttonAddTask.setTitle("Update Task", for: .normal)
            textViewTitle.text = self.task.title
            textViewTitle.textColor = UIColor.black
            textViewDescription.text = self.task.description
            textViewDescription.textColor = UIColor.black
            
            
        } else {
            labelAllTasks.text = "New Task"
            buttonAddTask.setTitle("Add Task", for: .normal)
            textViewTitle.text = "Title"
            textViewTitle.textColor = UIColor.lightGray
            textViewDescription.text = "Description"
            textViewDescription.textColor = UIColor.lightGray
        }
        
    }

    //Set the picker
    func setupPopupButton(){
        //Load users from User table
        print(statusNameList)
        let optionClosure = {(action: UIAction) in
            print(action.title)
            print("Item Selected")
            
        }
    
        menuElements.append(UIAction(title: "Select Status", handler: optionClosure))
        for status in statusNameList {
            menuElements.append( UIAction(title: status, handler: optionClosure))
        }
        popupButtonStatus.menu = UIMenu(children: menuElements)
        popupButtonStatus.showsMenuAsPrimaryAction = true
        popupButtonStatus.changesSelectionAsPrimaryAction = true
        
        if updateFlag {
            popupButtonStatus.setTitle(task.status, for: .normal)
        }
    }
    
    
    //Clear all fields
    func clearAllFields(){
        textViewTitle.text = ""
        textViewDescription.text = ""
        textViewTitle.text = "Title"
        textViewTitle.textColor = UIColor.lightGray
        textViewDescription.text = "Description"
        textViewDescription.textColor = UIColor.lightGray
        
    }
    
    
    //MARK: - IBAction
    
    @IBAction func buttonActionAddTask(_ sender: UIButton) {
        
        if popupButtonStatus.currentTitle == "Select Status" {
            
            let alertController = UIAlertController(title: "Select Status", message: "Please select a task status", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(OKAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
            
        } else {
            
            //Proceed with Add or update Task
          if updateFlag {
              task.title = textViewTitle.text
              task.description = textViewDescription.text
              task.status = popupButtonStatus.currentTitle
              
              //Update task
              addTaskViewModel.updateTask(task: task) { success, error in
                  if success! {
                      print("Task updated")
                      let alertController = UIAlertController(title: "Task Modified", message: "Your task has been modified", preferredStyle: .alert)
                      
                      // Create OK button
                      let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                          
                          // Task updated
                          print("Task updated")
                      }
                      alertController.addAction(OKAction)
                      
                      // Present Dialog message
                      self.present(alertController, animated: true, completion:nil)
                      
                      
                  } else {
                      print("Task update failed")
                  }
              }
              
          } else {
              
              let task = Task()
              task.id = Int64(taskCount) + 1
              task.title = textViewTitle.text
              task.description = textViewDescription.text
              task.status = popupButtonStatus.currentTitle
              
              //Add task
              addTaskViewModel.addTask(task: task) { success, error in
                  if success! {
                      print("Task inserted")
                      let alertController = UIAlertController(title: "Task Added", message: "Your task has been added", preferredStyle: .alert)
                      
                      // Create OK button
                      let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                          
                          // Task updated
                          print("Task added")
                          self.clearAllFields()
                      }
                      alertController.addAction(OKAction)
                      
                      // Present Dialog message
                      self.present(alertController, animated: true, completion:nil)
                      
                  } else{
                      print("Task adding failed")
                  }
              }
              
              
          }
            
            
        }
        
        
    }
    
    @IBAction func buttonActionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - TextView Delegate

extension AddTaskViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewTitle.text.isEmpty {
            textViewTitle.text = "Title"
            textViewTitle.textColor = UIColor.lightGray
        }
        if textViewDescription.text.isEmpty {
            textViewDescription.text = "Description"
            textViewDescription.textColor = UIColor.lightGray
        }
        
    }
}
