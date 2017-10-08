//
//  Artist.swift
//  BeBop
//
//  Created by Guilherme Mogames on 10/5/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

import ObjectMapper
import Foundation

class SearchArtist: Mappable {
    var name: String?
    var mediaId: Int?
    
    init() {
        
    }

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        mediaId <- map["media_id"]
    }
}
