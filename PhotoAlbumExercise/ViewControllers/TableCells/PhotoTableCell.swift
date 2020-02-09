//
//  PhotoTableCell.swift
//  PhotoAlbumExercise
//
//  Created by Carlos García Torres on 08/02/2020.
//

import UIKit

class PhotoTableCell: UITableViewCell {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbNailImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbNailImageView.layer.cornerRadius = 10
    }
}
