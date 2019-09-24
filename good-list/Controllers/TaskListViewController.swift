//
//  TaskListViewController.swift
//  good-list
//
//  Created by macbook on 9/24/19.
//  Copyright © 2019 Tanawat Polsuwan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: Screen,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var segmentPriority: UISegmentedControl!
    @IBOutlet weak var tableViewTaskList: UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filterTasks : [Task] = [Task]()

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath)
        cell.textLabel?.text = self.filterTasks[indexPath.row].title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navigationController = segue.destination as? UINavigationController,
            let addTaskViewController = navigationController.viewControllers.first as? AddTaskViewController else {
                return
        }

        addTaskViewController.subjectObservable.subscribe(onNext: { [weak self] (task) in

            let priority = Priority(rawValue: (self?.segmentPriority.selectedSegmentIndex)! - 1)

            var existingTask = self?.tasks.value
            existingTask?.append(task)
            self?.tasks.accept(existingTask!)
            self?.filterPriority(priority: priority)
            
        }).disposed(by: self.disposeBag)
        
    }
    
    @IBAction func priorityValueChange(_ sender: Any) {
        let priority = Priority(rawValue: self.segmentPriority.selectedSegmentIndex - 1)
        self.filterPriority(priority: priority)
    }
    
    private func updateTableView(){
        DispatchQueue.main.async {
            self.tableViewTaskList.reloadData()
        }
    }
    
    private func filterPriority(priority : Priority?) {
        
        if priority == nil {
            self.filterTasks = self.tasks.value
            self.updateTableView()
        } else {
            
            self.tasks.map { (tasks) -> [Task] in
                
                return tasks.filter({ (task) -> Bool in
                    
                    return task.priority == priority!
                    
                })}.subscribe(onNext: { [weak self] (tasks) in
                    
                    self?.filterTasks = tasks
                    self?.updateTableView()
                    
                }).disposed(by: self.disposeBag)

        }
        
    }
    
}
