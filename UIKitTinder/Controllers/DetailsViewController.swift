//
//  DetailsViewController.swift
//  TinderUIClone
//
//  Created by Jose Martins on 11/10/20.
//

import UIKit

class DetailsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "CellId"
    let headerId = "HeaderId"
    let profileId = "profileId"
    let photosId = "photosId"
    
    let likeButton: UIButton = .iconFooter(named: "icone-like")
    let deslikeButton: UIButton = .iconFooter(named: "icone-deslike")
    
    var backButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "icone-down"), for: .normal)
        button.backgroundColor = UIColor(red: 232/255, green: 88/255, blue: 54/255, alpha: 1)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        return button
    }()
    
    var userActionCallback: ((User?, Action) -> Void)?
    
    var user: User? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    init() {
        super.init(collectionViewLayout: HeaderLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 134, right: 0)
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(DetailProfileCell.self, forCellWithReuseIdentifier: profileId)
        collectionView.register(DetailPhotosCell.self, forCellWithReuseIdentifier: photosId)
        
        self.addFooter()
        self.addBackButton()
    }
    
    func addBackButton() {
        view.addSubview(backButton)
        backButton.frame = CGRect(
            x: UIScreen.main.bounds.width - 69,
            y: UIScreen.main.bounds.height * 0.7 - 24,
            width: 48,
            height: 48
        )
        backButton.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
    }
    
    func addFooter() {
        let stackView = UIStackView(arrangedSubviews: [UIView(), deslikeButton, likeButton, UIView()])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.fill(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 43, right: 16)
        )
        
        likeButton.addTarget(self, action: #selector(onClickLike), for: .touchUpInside)
        deslikeButton.addTarget(self, action: #selector(onClickDeslike), for: .touchUpInside)
    }
    
    @objc func onClickBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onClickLike() {
        self.userActionCallback?(self.user, .like)
        self.onClickBack()
    }
    
    @objc func onClickDeslike() {
        self.userActionCallback?(self.user, .deslike)
        self.onClickBack()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let originY = UIScreen.main.bounds.height * 0.7 - 24
        
        if scrollView.contentOffset.y > 0 {
            self.backButton.frame.origin.y = originY - scrollView.contentOffset.y
        } else {
            self.backButton.frame.origin.y = originY + scrollView.contentOffset.y * -1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! DetailHeaderView
        header.user = self.user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.bounds.width, height: view.bounds.height * 0.7)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileId, for: indexPath) as! DetailProfileCell
            cell.user = self.user
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photosId, for: indexPath) as! DetailPhotosCell
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width
        var height: CGFloat = UIScreen.main.bounds.width * 0.6
        
        if indexPath.item == 0 {
            let cell = DetailProfileCell(frame: CGRect(x: 0, y: 0, width: width, height: height))
            cell.user = self.user
            cell.layoutIfNeeded()
            
            let estimatedSize = cell.systemLayoutSizeFitting(CGSize(width: width, height: 1000))
            height = estimatedSize.height
        }
        
        
        
        return .init(width: width, height: height)
    }
    
}
