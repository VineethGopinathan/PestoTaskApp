//
//  TaskListTableViewCell.swift
//  PestoTaskApp
//
//  Created by Vineeth Gopinathan on 06/07/24.
//

import UIKit


protocol TaskListCellDelegate {
    func deleteTask(task: Task)
    func updateTask(task: Task)
}

class TaskListTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var labelTaskId: UILabel!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelStatus: UILabel!
    
    @IBOutlet weak var buttonEditTask: UIButton!
    
    @IBOutlet weak var buttonDeleteTask: UIButton!
    
    
    //MARK- Variables
    var task: Task?
    var delegate: TaskListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    //MARK: - Functions
    
    func loadTask(task:Task) {
        self.task = task
        labelTaskId.text = "\(task.id!)"
        labelTitle.text = task.title
        labelStatus.text = task.status
    }
    //MARK: - IBAction
    @IBAction func buttonActionEdit(_ sender: UIButton) {
        self.delegate?.updateTask(task: self.task!)
    }
    
    @IBAction func buttonActionDelete(_ sender: UIButton) {
        self.delegate?.deleteTask(task: self.task!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
