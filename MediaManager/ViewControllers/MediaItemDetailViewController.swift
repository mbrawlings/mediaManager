//
//  MediaItemDetailViewController.swift
//  MediaManager
//
//  Created by Matthew Rawlings on 10/5/22.
//

import UIKit

protocol DeleteItemDelegate: AnyObject {
    func deleteItem(mediaItem: MediaItem)
}

class MediaItemDetailViewController: UIViewController {

    var mediaItem: MediaItem?
    
    weak var delegate: DeleteItemDelegate?
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var markUnwatchedButton: UIButton!
    @IBOutlet weak var addWatchReminderButton: UIButton!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        properButtons()
//        detailAlert()
    }
    
    @IBAction func editMediaButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func addToFavoritesButtonTapped(_ sender: UIButton) {
        guard let mediaItem = mediaItem else { return }
        if mediaItem.isFavorite == false {
            mediaItem.isFavorite = true
        } else if mediaItem.isFavorite == true {
            mediaItem.isFavorite = false
        }
        MediaItemController.shared.updateMediaItem()
        properButtons()
    }
    
    @IBAction func addWatchReminderButtonTapped(_ sender: UIButton) {
//        guard let mediaItem = mediaItem else { return }
//        if mediaItem.reminderDate != nil {
//            addWatchReminderButton.setTitle("Edit Watch Reminder", for: .normal)
//        }
//        print(mediaItem.reminderDate)
    }
    
    @IBAction func markUnwatchedButtonTapped(_ sender: UIButton) {
        guard let mediaItem = mediaItem else { return }
        if mediaItem.wasWatched == false {
            mediaItem.wasWatched = true
        } else if mediaItem.wasWatched == true {
            mediaItem.wasWatched = false
        }
        MediaItemController.shared.updateMediaItem()
        properButtons()
    }
    
    @IBAction func deleteMovieButtonTapped(_ sender: UIButton) {
        guard let mediaItem = mediaItem else { return }
        MediaItemController.shared.deleteMediaItem(mediaItem: mediaItem)
        delegate?.deleteItem(mediaItem: mediaItem)
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Functions
    func setUpViews() {
        guard let mediaItem = mediaItem else { return }
        titleLabel.text = mediaItem.title
        ratingLabel.text = "\(mediaItem.rating)"
        releaseYearLabel.text = "Released in: \(mediaItem.year)"
        descriptionLabel.text = mediaItem.itemDescription
        
        descriptionLabel.isEditable = false
    }
    func properButtons() {
        guard let mediaItem = mediaItem else { return }
        mediaItem.mediaType != "Movie" ? deleteButton.setTitle("Delete TV Show", for: .normal) : deleteButton.setTitle("Delete Movie", for: .normal)
        mediaItem.isFavorite == true ? addFavoriteButton.setTitle("Remove From Favorites", for: .normal) : addFavoriteButton.setTitle("Add To Favorites", for: .normal)
        mediaItem.wasWatched == false ? markUnwatchedButton.setTitle("Mark As Watched", for: .normal) : markUnwatchedButton.setTitle("Mark As Unwatched", for: .normal)
    }

//    func detailAlert() {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let addToFavorites = UIAlertAction(title: "Add To Favorites", style: .default)
//        let addWatchReminder = UIAlertAction(title: "Add Watch Reminder", style: .default)
//        let markAsUnwatched = UIAlertAction(title: "Mark As Unwatched", style: .default)
//        let deleteMovie = UIAlertAction(title: "Delete Movie", style: .destructive)
//
//        [addToFavorites, addWatchReminder, markAsUnwatched, deleteMovie].forEach{alert.addAction($0)}
//
//        present(alert, animated: true)
//    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditVC" {
            let destination = segue.destination as? EditItemViewController
            destination?.delegate = self
            destination?.mediaItem = self.mediaItem
        } else if segue.identifier == "toReminderView" {
            let destination = segue.destination as? DatePickerViewController
            destination?.delegate = self
            destination?.date = self.mediaItem?.reminderDate
        }
    }
    

}

extension MediaItemDetailViewController: EditDetailDelegate {
    func mediaItemEdited(title: String, rating: Double, year: Int, description: String) {
        guard let mediaItem = mediaItem else { return }
        mediaItem.title = title
        mediaItem.rating = rating
        mediaItem.year = Int64(year)
        mediaItem.itemDescription = description
        MediaItemController.shared.updateMediaItem()
        setUpViews()
    }
}

extension MediaItemDetailViewController: DatePickerDelegate {
    func reminderDateEdited(date: Date) {
        guard let mediaItem = mediaItem else { return }
        mediaItem.reminderDate = date
        addWatchReminderButton.setTitle("Edit Watch Reminder", for: .normal)
        MediaItemController.shared.updateMediaReminderDate(mediaItem: mediaItem)
        setUpViews()
    }
    
    
}
