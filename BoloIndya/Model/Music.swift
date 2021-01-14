//
//  Music.swift
//  BoloIndya
//
//  Created by Rahul Garg on 13/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation

class Music {
    
    var author_name: String?
    var id: Int?
    var image_path: String?
    var s3_file_path: String?
    var title: String?
}

func getMusicDataFromJson(result: [String:Any]?) -> Music {
    let music = Music()
    
    music.id = result?["id"] as? Int
    music.author_name = result?["author_name"] as? String
    music.image_path = result?["image_path"] as? String
    music.s3_file_path = result?["s3_file_path"] as? String
    music.title = result?["title"] as? String
    
    return music
}
