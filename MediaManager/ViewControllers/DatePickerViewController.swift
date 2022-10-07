//
//  DatePickerViewController.swift
//  MediaManager
//
//  Created by Matthew Rawlings on 10/7/22.
//

import UIKit

protocol DatePickerDelegate: AnyObject {
    func reminderDateEdited(date: Date)
}

class DatePickerViewController: UIViewController {
    
    var date: Date?
    
    weak var delegate: DatePickerDelegate?
    
    //MARK: - Outlets

    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Action
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let delegate = delegate,
              let date = self.date
        else { return }
        delegate.reminderDateEdited(date: date)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerAdjusted(_ sender: UIDatePicker) {
        self.date = sender.date
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        datePicker.preferredDatePickerStyle = .wheels
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
