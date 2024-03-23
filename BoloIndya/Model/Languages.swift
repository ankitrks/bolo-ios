//
//  Languages.swift
//  BoloIndya
//
//  Created by apple on 8/2/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

class Languages {

    var id: Int
    var title: String
    var image: String
    
    init(id: Int, title: String, image: String) {
        self.id = id
        self.title = title
        self.image = image
    }
}

func getLanguages() -> [Languages] {
    var languages: [Languages] = []
    languages.append(Languages(id: 2, title: "Hindi", image: "hindi"))
    languages.append(Languages(id: 3, title: "Tamil", image: "tamil"))
    languages.append(Languages(id: 4, title: "Telugu", image: "telugu"))
    languages.append(Languages(id: 5, title: "Kannada", image: "kanada"))
    languages.append(Languages(id: 6, title: "Bengali", image: "bengali"))
    languages.append(Languages(id: 7, title: "Marathi", image: "marathi"))
    languages.append(Languages(id: 8, title: "Gujrati", image: "gujrati"))
    languages.append(Languages(id: 9, title: "Malayalam", image: "malayalam"))
    languages.append(Languages(id: 10, title: "Punjabi", image: "punjabi"))
    languages.append(Languages(id: 11, title: "Oriya", image: "oriya"))
    languages.append(Languages(id: 12, title: "Bhojpuri", image: "bhojpuri"))
    languages.append(Languages(id: 13, title: "Haryanvi", image: "harayanvi"))
    languages.append(Languages(id: 1, title: "English", image: "english"))
    languages.append(Languages(id: 14, title: "Sinhala", image: "sinhala"))
    return languages
}
