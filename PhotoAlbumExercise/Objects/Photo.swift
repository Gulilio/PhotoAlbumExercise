//
//  Photo.swift
//  PhotoAlbumExercise
//
//  Created by Carlos García Torres on 08/02/2020.
//

import Foundation
import UIKit

class Photo:NSObject {
    
    var id:String
    var albumId:String
    var title:String
    var url:String
    var thumbnailUrl:String
    var thumbnail:UIImage?
    var thumbnailImageLoaded:Bool = false
    
    init(id:String, albumId:String, title:String, url:String, thumbnailUrl:String) {
        
        self.id = id
        self.albumId = albumId
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
    
    func loadThumbnailImage() {
        
        // To not cause a deadlock in UI
        DispatchQueue.global().async {
            self.thumbnail = BBDDDataManager.loadImage(urlString: self.thumbnailUrl)
            self.thumbnailImageLoaded = true
        }
    }
}
