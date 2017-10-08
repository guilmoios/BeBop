//
//  SearchArtistsManager.swift
//  BeBop
//
//  Created by Guilherme Mogames on 10/5/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

import Foundation
import ObjectMapper

class ArtistsManager {
    static var shared = ArtistsManager()
    
    var searchedArtists: [SearchArtist] = []
    
    static func searchForArtists(_ query: String, completionHandler: @escaping (_ results: [SearchArtist]) -> ()) {
        
        let url = String(format: API.Endpoints.search, query)
        
        NetworkManager.shared.request(url, parameters: [:], showLoading: false) { (response) in
            
            if let data = response as? [String: Any] {
                if let status = data["status"] as? String {
                    if status == "success" {
                        if let artistData = data["data"] as? [[String: Any]] {
                            var tempData: [SearchArtist] = []
                            for artist in artistData {
                                if let artist = SearchArtist(JSON: artist) {
                                    tempData.append(artist)
                                }
                            }
                            ArtistsManager.shared.searchedArtists = tempData
                            completionHandler(tempData)
                            return
                        }
                    }
                }
            }
            completionHandler([])
        }
    }
    
    
    static func getArtistDetails(_ name: String, completionHandler: @escaping (_ object: Artist?) -> ()) {
        let url = String(format: API.Endpoints.artist, name)
        
        NetworkManager.shared.request(url, parameters: [:]) { (response) in
            
            if let responseDict = response as? [String: Any] {
                do{
                    let artist = try Artist(dictionary: responseDict)
                    completionHandler(artist)
                } catch {
                    print("error")
                    completionHandler(nil)
                }
                return
            }
            completionHandler(nil)
        }
    }
}
