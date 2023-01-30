//
//  SlidePhotoCell.swift
//  TinderUIClone
//
//  Created by Jose Martins on 11/10/20.
//

import UIKit

class SlidePhotoCell: UICollectionViewCell {
    var photoImageView: UIImageView = .photoImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(photoImageView)
        photoImageView.fillWithSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
