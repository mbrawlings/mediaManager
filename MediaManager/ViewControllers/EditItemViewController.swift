//
//  EditItemViewController.swift
//  MediaManager
//
//  Created by Matthew Rawlings on 10/5/22.
//

import UIKit

protocol EditDetailDelegate: AnyObject {
    func mediaItemEdited(title: String, rating: Double, year: Int, description: String)
}

class EditItemViewController: UIViewController {

    var mediaItem: MediaItem?
    
    var ratingValue = 10.0
    
    weak var delegate: EditDetailDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleTextFied: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Action
    
    @IBAction func doneBarButtonTapped(_ sender: Any) {
        guard let title = titleTextFied.text,
              !title.isEmpty,
              let yearText = yearTextField.text,
              let year = Int(yearText),
              year >= 1800 && year <= Calendar.current.component(.year, from: Date()),
              let description = descriptionTextView.text,
              !description.isEmpty
        else {
            let alert = UIAlertController(title: "Invalid Update", message: "Please fill out all fields", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
        delegate?.mediaItemEdited(title: title, rating: ratingValue, year: year, description: description)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sliderAdjusted(_ sender: UISlider) {
        let newRating = Double(sender.value).roundTo(places: 1)
        ratingValue = newRating
        ratingLabel.text = "Rating: \(ratingValue)"
    }
    
    
    //MARK: - Helper Functions
    func setupView() {
        guard let mediaItem = mediaItem else { return }
        titleTextFied.text = mediaItem.title
        ratingLabel.text = "Rating: \(mediaItem.rating)"
        slider.value = Float(mediaItem.rating)
        ratingValue = mediaItem.rating
        yearTextField.text = "\(mediaItem.year)"
        descriptionTextView.text = mediaItem.itemDescription
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
