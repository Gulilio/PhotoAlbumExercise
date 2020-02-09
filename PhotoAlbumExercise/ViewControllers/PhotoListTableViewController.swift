//
//  PhotoListTableViewController.swift
//  PhotoAlbumExercise
//
//  Created by Carlos García Torres on 08/02/2020.
//

import UIKit


class PhotoListTableViewController: UIViewController, BBDDDataManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    //VARIABLES
    
    let bbddDataManager:BBDDDataManager = BBDDDataManager()
    var idOfAlbum:String = "1"
    var photosListed:[Photo] = [Photo]()
    var timer:Timer!
        
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.bbddDataManager.delegate = self
        
        loadPhotos()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    
    func loadPhotos() {
        
        DispatchQueue.main.async {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.startAnimating()
        }
        bbddDataManager.getAlbumPhotos(albumId: idOfAlbum)
    }
    
    
    //Timer to check if all the thumbnails were downloaded
    @objc func fireTimer() {
        
        var photosLoaded:Int = 0
        for photo in photosListed {
            if (photo.thumbnailImageLoaded) {
                photosLoaded = photosLoaded+1
            } else {
                break
            }
        }
        
        
        if (photosLoaded == photosListed.count) {
            print("All the thumbnails were loaded")
            
            //No need for the timer now
            timer.invalidate()
            
            showTableCells()
        }
    }
    
    
    func showTableCells() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.loadingIndicatorView.isHidden = true
            self.loadingIndicatorView.stopAnimating()
        }
        
    }
    
    
    //TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosListed.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableCell", for: indexPath) as! PhotoTableCell
        cell.titleLabel.text = photosListed[indexPath.row].title
        cell.thumbNailImageView.image = photosListed[indexPath.row].thumbnail
        //setThumbnail(url: photosListed[indexPath.row].thumbnailUrl, imageView: cell.imageView!)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //We open the selected album
        print("Pressed:\(indexPath.row)")
        
        let photoDetailViewController: PhotoDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        photoDetailViewController.photo = photosListed[indexPath.row]
        
        self.navigationController?.pushViewController(photoDetailViewController, animated: true)
    }
    
    
    //------------------------
    //BBDDDataManager Delegate
    //------------------------
    func didGetPhotosOk(photos: [Photo]) {
        
        photosListed.removeAll()
        
        photosListed = photos
        
        for photo in photosListed {
            
            photo.loadThumbnailImage()
        }
        
        //The data is loading, we check with the timer if all the images has been downloaded to show the table
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    
    func didGetPhotosError(result: String) {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: "Error loading Photos",
                                                    message: "The Photos cannot be loaded due to:\n\n\(result)",
                                                    preferredStyle: .alert)
                
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                                    style: .default, handler: {
                                                        action in
                                                        
                    self.loadPhotos()
            }))
            
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
}

