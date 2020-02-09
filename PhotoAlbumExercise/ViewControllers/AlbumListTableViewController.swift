//
//  AlbumListTableViewController.swift
//  PhotoAlbumExercise
//
//  Created by Carlos García Torres on 08/02/2020.
//

import UIKit


class AlbumListTableViewController: UITableViewController, BBDDDataManagerDelegate {
    
    
    //VARIABLES
    let bbddDataManager:BBDDDataManager = BBDDDataManager()
    var albumsListed:[Album] = [Album]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.bbddDataManager.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadAlbums()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    
    func loadAlbums() {
        
        bbddDataManager.getAlbums()
    }
    
    
    //TableView functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumsListed.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableCell", for: indexPath) as! AlbumTableCell
        cell.titleLabel.text = albumsListed[indexPath.row].title
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //We open the selected album
        print("Pressed:\(indexPath.row)")
        
        let photoListTableViewController: PhotoListTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoListTableViewController") as! PhotoListTableViewController
        photoListTableViewController.idOfAlbum = "\(indexPath.row)"
        
        self.navigationController?.pushViewController(photoListTableViewController, animated: true)
    }
    
    
    //------------------------
    //BBDDDataManager Delegate
    //------------------------
    func didGetAlbumsOk(albums: [Album]) {
        
        albumsListed.removeAll()
        
        albumsListed = albums
        
        self.tableView.reloadData()
    }
    
    
    func didGetAlbumsError(result: String) {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: "Error loading Albums",
                                                    message: "The albums cannot be loaded due to:\n\n\(result)",
                                                    preferredStyle: .alert)
                
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                                    style: .default, handler: {
                                                        action in
                                                        
                    self.loadAlbums()
            }))
            
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
}
