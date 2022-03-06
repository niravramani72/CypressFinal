//
//  HomeViewController.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Variables
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = HomeViewModel()
    var dataSource : HomeDataSource?
    
    //MARK: - Activity Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataSource = HomeDataSource(collectionView: collectionView, viewModel: viewModel, vc: self)
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        viewModel.apiDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        //Note:- Delay is added to demonstrate realm
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.viewModel.getAlbumsData()
        }
    }
    
}
//MARK: - ViewModel protocols
extension HomeViewController: ProtocolHomeViewModel {
    func apiDataFetched(isReloadRequired: Bool) {
        activityIndicator.stopAnimating()
        if isReloadRequired {
            collectionView.reloadData()
        }
    }
}
