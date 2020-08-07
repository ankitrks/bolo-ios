//
//  HashTag.swift
//  BoloIndya
//
//  Created by apple on 7/17/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

class HashTag {

    var id: Int
    var title: String
    var videos: [Topic]
    var total_views: String
    var image: String
    
    init() {
        self.id = 0
        self.title = ""
        self.videos = []
        self.total_views = ""
        self.image = ""
    }
}
