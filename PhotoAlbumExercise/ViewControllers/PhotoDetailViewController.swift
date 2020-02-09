//
//  PhotoDetailViewController.swift
//  PhotoAlbumExercise
//
//  Created by Carlos García Torres on 09/02/2020.
//

import UIKit

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!
    
    
    //VARIABLES
    var photo:Photo!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 10.0
        self.title = photo.title
        
        loadPhoto()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    
    func loadPhoto() {
        
        DispatchQueue.main.async {
            
            //Loading Activity
            self.loadingActivityView.isHidden = false
            self.loadingActivityView.startAnimating()
            
            self.imageView.image = BBDDDataManager.loadImage(urlString: self.photo.url)
            
            self.loadingActivityView.isHidden = true
            self.loadingActivityView.stopAnimating()
        }
    }
    
    //---------------------------------
    // ScrollView Delegate
    //---------------------------------
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

