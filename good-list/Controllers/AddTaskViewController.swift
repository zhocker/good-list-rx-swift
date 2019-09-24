//
//  AddTaskViewController.swift
//  good-list
//
//  Created by macbook on 9/24/19.
//  Copyright © 2019 Tanawat Polsuwan. All rights reserved.
//

import UIKit
import RxSwift

class AddTaskViewController: Screen {
    
    private let subjectTask = PublishSubject<Task>()
    var subjectObservable : Observable<Task> {
        return self.subjectTask.asObserver()
    }
    
    @IBOutlet weak var segmentControlPriority : UISegmentedControl!
    @IBOutlet weak var textFieldTask : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func barButtonSaveAction() {
        
        guard let priority = Priority(rawValue: segmentControlPriority.selectedSegmentIndex),
            let title : String = self.textFieldTask.text else {
            return
        }
        
        let task = Task(title : title, priority : priority)
        subjectTask.onNext(task)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion:nil)
        }

    }
    
    @IBAction func barButtonCloseAction() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion:nil)
        }
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
