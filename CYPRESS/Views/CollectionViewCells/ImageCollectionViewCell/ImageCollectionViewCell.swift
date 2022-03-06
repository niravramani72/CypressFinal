//
//  ImageCollectionViewCell.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    //MARK: - Variables
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelImageId: UILabel!
    
    var urlString = ""
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage()
        imageView.backgroundColor = .lightGray
    }
}
