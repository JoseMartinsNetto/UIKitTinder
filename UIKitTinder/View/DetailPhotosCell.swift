//
//  DetailPhotosCell.swift
//  TinderUIClone
//
//  Created by Jose Martins on 11/10/20.
//

import UIKit

class DetailPhotosCell: UICollectionViewCell {
    
    let descriptionLabel: UILabel = .textBoldLabel(16)
    let slidePhotosViewController = SlidePhotosViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        descriptionLabel.text = "Fotos recentes do Instagram"
        
        addSubview(descriptionLabel)
        descriptionLabel.fill(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 20, bottom: 0, right: 20)
        )
        
        addSubview(slidePhotosViewController.view)
        slidePhotosViewController.view.fill(
            top: descriptionLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
