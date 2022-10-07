//
//  MediaItemTableViewController.swift
//  MediaManager
//
//  Created by Matthew Rawlings on 10/5/22.
//

import UIKit

class MediaItemTableViewController: UITableViewController {
    
    var items: [MediaItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaItemCell", for: indexPath)

        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = String(item.rating)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let mediaToDelete = items[indexPath.row]
            MediaItemController.shared.deleteMediaItem(mediaItem: mediaToDelete)
            guard let index = items.firstIndex(of: mediaToDelete) else { return }
            items.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? MediaItemDetailViewController else { return }
            let mediaDetails = items[indexPath.row]
            destination.delegate = self
            destination.mediaItem = mediaDetails
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    

    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */



}

extension MediaItemTableViewController: DeleteItemDelegate {
    func deleteItem(mediaItem: MediaItem) {
        guard let index = items.firstIndex(of: mediaItem) else { return }
        items.remove(at: index)
        tableView.reloadData()
    }
}
