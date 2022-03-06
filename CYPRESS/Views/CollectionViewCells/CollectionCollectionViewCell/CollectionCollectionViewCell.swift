//
//  CollectionCollectionViewCell.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import UIKit

class CollectionCollectionViewCell: UICollectionViewCell {

    //MARK: - Variables
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel : HomeViewModel!
    var sectionIndex = 0
    
    //MARK: - Class methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(ImageCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // reset collection view and scrolled to starting to avoid reusability issue
        if collectionView.numberOfSections > 0 && collectionView.numberOfItems(inSection: 0) > 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        }
        collectionView.reloadData()
    }
}

//MARK: - UICollectionView Delegate and DataSource
extension CollectionCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.infiniteGetPhotoCount(at: sectionIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 3) - 6, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        cell.imageView.backgroundColor = .lightGray
        
        let photoIndex = viewModel.infiniteGetPhotoIndex(for: sectionIndex, index: indexPath.item)
        
        cell.labelImageId.text = "\(viewModel.getPhotoId(at: sectionIndex, index: photoIndex))"
        if let urlString = viewModel.getPhotoURL(at: sectionIndex, index: photoIndex) {
            if let url = URL(string: urlString) {
                cell.urlString = urlString
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                //to avoid reusability issues of collection cell
                                if cell.urlString == urlString {
                                    cell.imageView.image = image
                                }
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // for infinite scrolling
        var offset = collectionView.contentOffset
        let width = collectionView.contentSize.width
        if offset.x < width/4 {
            offset.x += width/2
            collectionView.setContentOffset(offset, animated: false)
        } else if offset.x > width/4 * 3 {
            offset.x -= width/2
            collectionView.setContentOffset(offset, animated: false)
        }
    }
}
