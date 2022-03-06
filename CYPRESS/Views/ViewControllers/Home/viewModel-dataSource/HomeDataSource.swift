//
//  HomeDataSource.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import Foundation
import UIKit

class HomeDataSource: NSObject {
    
    //MARK: - Variables
    private let collectionView: UICollectionView
    private let vc: HomeViewController
    var viewModel : HomeViewModel
    
    
    //MARK: - Class Methods
    init(collectionView: UICollectionView,viewModel: HomeViewModel,vc:HomeViewController) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        self.vc = vc
        super.init()
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.register(CollectionCollectionViewCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: HeaderCollectionReusableView.categoryHeaderId, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        setupCollectionLayout()
        collectionView.reloadData()
    }
    
    func setupCollectionLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { sectionNumber, env in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets.trailing = 0
            item.contentInsets.bottom = 10
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = [
                .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: HeaderCollectionReusableView.categoryHeaderId, alignment: .topLeading)]
            
            return section
        }
        
    }
}

//MARK: - UICollectionView Delegate and DataSource Methods
extension HomeDataSource: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.infiniteGetTotalNumberOfAlbums()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        
        let index = viewModel.infiniteGetAlbumIndex(for: indexPath.section)
        
        header.label.text = "\(viewModel.getAlbumId(at: index)) - \(viewModel.getAlbumTitle(at: index))"
        header.label.numberOfLines = 0
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCollectionViewCell.identifier, for: indexPath) as! CollectionCollectionViewCell
        cell.viewModel = viewModel
        cell.sectionIndex = viewModel.infiniteGetAlbumIndex(for: indexPath.section)
        cell.collectionView.tag = viewModel.infiniteGetAlbumIndex(for: indexPath.section)
        cell.collectionView.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // for infinite scrolling
        var offset = collectionView.contentOffset
        let height = collectionView.contentSize.height
        if offset.y < height/4 {
            offset.y += height/2
            collectionView.setContentOffset(offset, animated: false)
        } else if offset.y > height/4 * 3 {
            offset.y -= height/2
            collectionView.setContentOffset(offset, animated: false)
        }
    }
    
}

