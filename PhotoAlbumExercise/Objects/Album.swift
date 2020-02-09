//
//  Album.swift
//  PhotoAlbumExercise
//
//  Created by Carlos García Torres on 08/02/2020.
//

import Foundation

class Album:NSObject {
    
    var id:String
    var userId:String
    var title:String
    var thumbNailUrl:String?
    
    init(id:String, albumId:String, title:String) {
        
        self.id = id
        self.userId = albumId
        self.title = title
    }
    
}
