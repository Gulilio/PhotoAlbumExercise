//
//  BBDDDataManager.swift
//  PhotoAlbumExercise
//
//  Created by Carlos García Torres on 08/02/2020.
//

import Foundation
import Alamofire
import SwiftyJSON

class BBDDDataManager:NSObject {
    
    //Types of functions to get data
    enum FunctionType:String {
        
        case GETALBUMSLIST = "/albums"
        case GETPHOTOS = "/photos"
    }
    
    
    
    //VARIABLES
    let baseURL:String = "https://jsonplaceholder.typicode.com"
    weak var delegate:BBDDDataManagerDelegate?

    
    
    override init() {
        
        super.init()
    }
    
    

    func getAlbums() {
        
        let lastPartURL:String = "\(FunctionType.GETALBUMSLIST.rawValue)"
        getData(lastPartURL: lastPartURL, functionType: .GETALBUMSLIST)
    }
    
    
    func getAlbumPhotos(albumId:String) {
        
        let lastPartURL:String = "\(FunctionType.GETPHOTOS.rawValue)?albumId=\(albumId)"
        getData(lastPartURL: lastPartURL, functionType: .GETPHOTOS)
    }
    
    
    //Process the get with the correct url
    func getData(lastPartURL:String, functionType:FunctionType) {
        
        let url = baseURL + lastPartURL
        print("url: \(url)")
        
        //We use Alamofire + SwiftJSON (quick and simple)
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                
                print(json)
                self.processResponse(functionType: functionType, data:json)
                
            case .failure(let error):
                print(error)
                self.processErrorResponse(functionType: functionType, result: error.localizedDescription)
            }

        }
    }
    
    
    //Process the response and give the data to the appropiate delegate
    func processResponse(functionType:FunctionType, data:JSON) {
        
        switch functionType {
            
        case .GETALBUMSLIST:
            
            var albums:[Album] = [Album]()
            
            for value in data.arrayValue {
                guard
                    let id = value.dictionaryValue["id"]?.stringValue,
                    let albumId = value.dictionaryValue["userId"]?.stringValue,
                    let title = value.dictionaryValue["title"]?.stringValue
                
                    else {
                        print("JSON error")
                        self.delegate?.didGetAlbumsError?(result: "JSON ERROR")
                        return
                }
                    
                let album = Album(id: id, albumId: albumId, title: title)
                albums.append(album)
            }
            
            self.delegate?.didGetAlbumsOk!(albums: albums)
            break
            
        case .GETPHOTOS:
            
            var photos:[Photo] = [Photo]()
            
            for value in data.arrayValue {
                guard
                    let id = value.dictionaryValue["id"]?.stringValue,
                    let albumId = value.dictionaryValue["albumId"]?.stringValue,
                    let title = value.dictionaryValue["title"]?.stringValue,
                    let url = value.dictionaryValue["url"]?.stringValue,
                    let thumbnailUrl = value.dictionaryValue["thumbnailUrl"]?.stringValue
                
                    else {
                        print("JSON error")
                        self.delegate?.didGetPhotosError?(result: "JSON ERROR")
                        return
                }
                let photo = Photo(id: id, albumId: albumId, title: title, url: url, thumbnailUrl: thumbnailUrl)
                photos.append(photo)
            }
            
            self.delegate?.didGetPhotosOk!(photos: photos)
            break
        }
    }
    
    
    //Gives the error response appropiate delegate
    func processErrorResponse(functionType:FunctionType, result:String) {
        
        switch functionType {
         
        case .GETALBUMSLIST:
            self.delegate?.didGetAlbumsError!(result:result)
            break
        case .GETPHOTOS:
            self.delegate?.didGetPhotosError!(result:result)
            break
        }
    }
    
    
    //To load a give an UIImage
    static func loadImage(urlString:String) -> UIImage {
        
        //Just in case the url is not valid
        var image:UIImage!
        guard
            let imageURL = URL(string: urlString)
            else {
            
                image = UIImage(named: "cancel_icon.png")
                return image
        }


        guard
            let imageData = try? Data(contentsOf: imageURL)
            else {
                print("Error loading image")
                image = UIImage(named: "cancel_icon.png")
                return image
            }

        image = UIImage(data: imageData)
        return image
    }
    
}




@objc protocol BBDDDataManagerDelegate: class {
    
    @objc optional func didGetAlbumsOk(albums:[Album])
    @objc optional func didGetAlbumsError(result:String)
    
    @objc optional func didGetPhotosOk(photos:[Photo])
    @objc optional func didGetPhotosError(result:String)
}

