//
//  MediaItem+Convenience.swift
//  MediaManager
//
//  Created by Matthew Rawlings on 10/3/22.
//

import CoreData

extension MediaItem {
    @discardableResult convenience init(title: String, mediaType: String, year: Int, rating: Double, itemDescription: String, isFavorite: Bool, wasWatched: Bool, reminderDate: Date? = nil, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.title = title
        self.mediaType = mediaType
        self.year = Int64(year)
        self.rating = rating
        self.itemDescription = itemDescription
        self.isFavorite = isFavorite
        self.wasWatched = wasWatched
        self.reminderDate = reminderDate
        self.id = UUID()
    }
}
