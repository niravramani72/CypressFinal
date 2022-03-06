//
//  HeaderCollectionReusableView.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {

    //MARK: - Variables
    static let categoryHeaderId = "categoryHeaderId"
    
    let label =  UILabel()
    
    //MARK: - Class Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.text = ""
        label.numberOfLines = 2
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
}
