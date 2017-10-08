//
//  FavoritesManager.swift
//  BeBop
//
//  Created by Guilherme Mogames on 10/6/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

import UIKit
import CoreData

class FavoritesManager {
    static var shared = FavoritesManager()
    var favorites: [NSManagedObject] = []
    
    static func fetchAllFavorites() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")

        do {
            FavoritesManager.shared.favorites = try managedContext.fetch(fetchRequest)
            return FavoritesManager.shared.favorites
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    static func addToFavorites(_ artist: SearchArtist) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, artist.name != nil, artist.mediaId != nil else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let saveArtist = Favorites(context: managedContext)
        saveArtist.name = artist.name!
        saveArtist.mediaId = Int64(artist.mediaId!)
        
        do {
            try managedContext.save()
            FavoritesManager.shared.favorites.append(saveArtist)
        } catch let error as NSError {
            print("Error saving favorite artist. \(error) - \(error.userInfo)")
        }
    }
    
    static func removeFromFavorites(_ name: String?) {
        
        let findObject = FavoritesManager.shared.favorites.filter { ($0.value(forKeyPath: "name") as? String) == name }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let favoriteObject = findObject.first else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(favoriteObject)
        
        do {
            try managedContext.save()
            _ = FavoritesManager.fetchAllFavorites()
        } catch let error as NSError {
            print("Error saving favorite artist. \(error) - \(error.userInfo)")
        }
    }
    
    static func isArtistInFavorites(_ name: String) -> Bool {
        
        let findObject = FavoritesManager.shared.favorites.filter { ($0.value(forKeyPath: "name") as? String) == name }
        return findObject.count > 0
    }
    
    static func getSearchArtistFromData(_ object: NSManagedObject) -> SearchArtist {
        
        let artist = SearchArtist()
        artist.mediaId = object.value(forKeyPath: "mediaId") as? Int
        artist.name = object.value(forKeyPath: "name") as? String
        
        return artist
    }
}
