//
//  Category.swift
//  BoloIndya
//
//  Created by apple on 7/24/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

class Category {

    var id: Int
    var title: String
    var image: String
    var isSelected: Bool
    
    init() {
        self.id = 0
        self.title = ""
        self.image = ""
        self.isSelected = false
    }
}
