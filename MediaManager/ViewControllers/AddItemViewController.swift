//
//  AddItemViewController.swift
//  MediaManager
//
//  Created by Matthew Rawlings on 10/4/22.
//

import UIKit

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Outlets
    @IBOutlet weak var movieCheckbox: UIButton!
    @IBOutlet weak var tvShowCheckbox: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var isFavoriteControl: UISegmentedControl!
    @IBOutlet weak var hasWatchedControl: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: - Properties
    var yearPickerValue = Calendar.current.component(.year, from: Date())
    var isMovie: Bool?
    var ratingValue = 10.0
    var isFavorite = false
    var hasWatched = false
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        yearPicker.dataSource = self
        yearPicker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired), name: NSNotification.Name(rawValue: Strings.mediaReminderNotification), object: nil)
    }
    
    // viewWillAppear would go here //
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc private func reminderFired() {
        view.backgroundColor = .systemRed
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .white
        }
    }
    
    //MARK: - Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let currentYear = Calendar.current.component(.year, from: Date())

        return currentYear - 1799
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let year = Calendar.current.component(.year, from: Date()) - row
        return String(year)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearPickerValue = yearPickerValue - row
    }
    
    //MARK: - Action
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard isMovie != nil, let isMovie = isMovie,
            let mediaType = isMovie ? "Movie" : "TV Show" else {
            print("movie is nil")
            return }
        guard let title = titleTextField.text, !title.isEmpty else {
            print("title was empty")
            return }
        guard let itemDescription = descriptionTextView.text, !itemDescription.isEmpty else {
            print("description was empty")
            return }
        
        MediaItemController.shared.createMediaItem(title: title, mediaType: mediaType, year: yearPickerValue, itemDescription: itemDescription, rating: ratingValue, wasWatched: hasWatched, isFavorite: isFavorite)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func movieCheckboxTapped(_ sender: UIButton) {
        movieCheckbox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        tvShowCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
        isMovie = true
    }
    
    @IBAction func tvShowCheckboxTapped(_ sender: UIButton) {
        movieCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
        tvShowCheckbox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        isMovie = false
    }

    @IBAction func ratingSliderAdjusted(_ sender: UISlider) {
        let newRating = Double(sender.value).roundTo(places: 1)
        ratingValue = newRating
        ratingLabel.text = "Rating: \(newRating)"
    }
    
    @IBAction func isFavoriteControlToggled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isFavorite = true
        } else {
            isFavorite = false
        }
    }
    
    @IBAction func hasWatchedControlToggled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            hasWatched = true
        } else {
            hasWatched = false
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

extension Double {
   func roundTo(places:Int) -> Double {
      let divisor = pow(10.0, Double(places))
      return (self * divisor).rounded() / divisor
   }
}
