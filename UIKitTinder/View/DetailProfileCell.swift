//
//  DetailProfileCell.swift
//  TinderUIClone
//
//  Created by Jose Martins on 11/10/20.
//

import UIKit

class DetailProfileCell: UICollectionViewCell {
    let nameLabel: UILabel = .textBoldLabel(32)
    let ageLabel: UILabel = .textLabel(28)
    let messageLabel: UILabel = .textLabel(18, numberOfLines: 2)
    
    var user: User? {
        didSet {
            if let user = user {
                nameLabel.text = user.name
                ageLabel.text = String(user.age)
                messageLabel.text = user.description
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nameAgeStackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel, UIView()])
        nameAgeStackView.spacing = 12
        
        let stackView = UIStackView(arrangedSubviews: [nameAgeStackView, messageLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.fillWithSuperView(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
