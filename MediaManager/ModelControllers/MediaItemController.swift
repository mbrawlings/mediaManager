//
//  MediaItemController.swift
//  MediaManager
//
//  Created by Matthew Rawlings on 10/3/22.
//

import CoreData

class MediaItemController {
    static let shared = MediaItemController()
    let notificationScheduler = NotificationScheduler()
    
    private init() {
        fetchMediaItems()
    }
    
    private lazy var fetchRequest: NSFetchRequest<MediaItem> = {
        let request = NSFetchRequest<MediaItem>(entityName: "MediaItem")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    var mediaItems: [MediaItem] = []
    var favorites: [MediaItem] = []
    var movies: [MediaItem] = []
    var tvShows: [MediaItem] = []
    var sections: [[MediaItem]] {[favorites, movies, tvShows]}

    private func fetchMediaItems() {
        favorites = []
        movies = []
        tvShows = []
        let mediaItems = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        self.mediaItems = mediaItems
        sectionOffMediaItems()
    }
    func sectionOffMediaItems() {
        for item in mediaItems {
            if item.isFavorite == true {
                favorites.append(item)
            }
            if item.mediaType == "Movie" {
                movies.append(item)
            } else if item.mediaType == "TV Show"{
                tvShows.append(item)
            }
        }
    }
    func createMediaItem(title: String, mediaType: String, year: Int, itemDescription: String, rating: Double, wasWatched: Bool, isFavorite: Bool) {
        let mediaItem = MediaItem(title: title, mediaType: mediaType, year: year, rating: rating, itemDescription: itemDescription, isFavorite: isFavorite, wasWatched: wasWatched)
        mediaItems.append(mediaItem)
        CoreDataStack.saveContext()
        fetchMediaItems()
    }
    func deleteMediaItem(mediaItem: MediaItem) {
        CoreDataStack.context.delete(mediaItem)
        CoreDataStack.saveContext()
        fetchMediaItems()
    }
    func updateMediaItem() {
        CoreDataStack.saveContext()
        fetchMediaItems()
    }
    func updateMediaReminderDate(mediaItem: MediaItem) {
        notificationScheduler.scheduleNotifications(mediaItem: mediaItem)
        CoreDataStack.saveContext()
        fetchMediaItems()
    }
}

