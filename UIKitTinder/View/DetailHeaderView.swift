//
//  DetailHeaderView.swift
//  TinderUIClone
//
//  Created by Jose Martins on 11/10/20.
//

import UIKit

class DetailHeaderView: UICollectionReusableView {
    var photoImageView: UIImageView = .photoImageView()
    
    var user: User? {
        didSet {
            if let user = user {
                photoImageView.image = UIImage(named: user.image)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.fillWithSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
