//
//  CombineCardView.swift
//  TinderUIClone
//
//  Created by Jose Martins on 10/10/20.
//

import UIKit

class CombineCardView: UIView {
    
    var user: User? {
        didSet {
            if let user =  user {
                photoImageView.image = UIImage(named: user.image)
                nameLabel.text = user.name
                ageLabel.text = String(user.age)
                descriptionLabel.text = user.description
            }
        }
    }
    
    var onTapStackViewCallBack: ((User) -> Void)?
    
    let photoImageView: UIImageView = .photoImageView()
    let likeImageView: UIImageView = .iconImageView(named: "card-like")
    let deslikeImageView: UIImageView = .iconImageView(named: "card-deslike")
    
    let nameLabel: UILabel = .textBoldLabel(32, textColor: .white )
    let ageLabel: UILabel = .textLabel(28, textColor: .white )
    let descriptionLabel: UILabel = .textLabel(18, textColor: .white,numberOfLines: 2)
    
    override init( frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(photoImageView)
        
        addSubview(deslikeImageView)
        deslikeImageView.fill(
            top: topAnchor,
            leading: nil,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 0, right: 20)
        )
        
        addSubview(likeImageView)
        likeImageView.fill(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 20, left: 20, bottom: 0, right: 0)
        )
        
        photoImageView.fillWithSuperView()
        
        nameLabel.addShadow()
        ageLabel.addShadow()
        descriptionLabel.addShadow()
        
        let nameLabelStackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel, UIView()])
        nameLabelStackView.spacing = 12
        
        let stackView = UIStackView(arrangedSubviews: [nameLabelStackView, descriptionLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        addSubview(stackView)
        
        stackView.fill(
            top: nil,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 16, right: 16)
        )
        
        let stackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapUserInfo))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(stackViewTapGesture)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onTapUserInfo() {
        if let user = self.user {
            self.onTapStackViewCallBack?(user)
        }
    }

}
