//
//  CombineViewController.swift
//  TinderUIClone
//
//  Created by Jose Martins on 10/10/20.
//

import UIKit

enum Action {
    case like
    case superLike
    case deslike
}

class CombineViewController: UIViewController {
    var users: [User] = []
    
    let profileButton: UIButton = .iconHeader(named: "icone-perfil")
    let chatButton: UIButton = .iconHeader(named: "icone-chat")
    let logoButton: UIButton = .iconHeader(named: "icone-logo")
    
    let deslikeButton: UIButton = .iconFooter(named: "icone-deslike")
    let likeButton: UIButton = .iconFooter(named: "icone-like")
    let superlikeButton: UIButton = .iconFooter(named: "icone-superlike")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        let loading = Loading(frame: view.frame)
        view.insertSubview(loading, at: 0)
        
        self.findUsers()
        self.addHeader()
    }
    
    func findUsers() {
        UserService.instance.findUsers{ (users, err) in
            if let users = users {
                self.users = users
                self.addCards()
                self.addFooter()
            }
        }
    }
    
    func addHeader() {
        let window = UIApplication.shared.windows.first {$0.isKeyWindow}
        let top: CGFloat = window?.safeAreaInsets.top ?? 44
        
        let stackView = UIStackView(arrangedSubviews: [profileButton, logoButton, chatButton])
        stackView.distribution = .equalSpacing
        
        view.addSubview(stackView)
        stackView.fill(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: top, left: 16, bottom: 0, right: 16)
        )
    }
    
    func addFooter() {
        let stackView = UIStackView(arrangedSubviews: [UIView(),deslikeButton, superlikeButton, likeButton,UIView()])
        stackView.distribution = .equalSpacing
        
        view.addSubview(stackView)
        stackView.fill(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 34, right: 16)
        )
        
        deslikeButton.addTarget(self, action: #selector(onClickDeslike), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(onClickLike), for: .touchUpInside)
        superlikeButton.addTarget(self, action: #selector(onClickSuperlike), for: .touchUpInside)
    }
    
    func addCards() {
        for user in self.users {
            let card = CombineCardView()
            card.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: view.bounds.height * 0.7)
            card.center = view.center
            card.user = user
            card.tag = user.id
            
            card.onTapStackViewCallBack = { (data) in
                self.viewDetails(user)
            }
            
            let gesture = UIPanGestureRecognizer()
            gesture.addTarget(self, action: #selector(handleCardAnimation))
            
            card.addGestureRecognizer(gesture)
            
            view.insertSubview(card, at: 1)
        }
    }
    
    func viewDetails(_ user: User) {
        let detailsViewController = DetailsViewController()
        detailsViewController.user = user
        detailsViewController.modalPresentationStyle = .fullScreen
        
        detailsViewController.userActionCallback = { (user, action) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if action == .like {
                    self.onClickLike()
                } else {
                    self.onClickDeslike()
                }
            }
        }
        
        self.present(detailsViewController, animated: true, completion: nil)
    }
    
    func verifyMatch(user: User) {
        if user.match {
            let matchViewController = MatchViewController()
            matchViewController.user = user
            matchViewController.modalPresentationStyle = .fullScreen
            
            self.present(matchViewController, animated: true, completion: nil)
        }
    }
    
    func animateCard(rotationAngle: CGFloat, action: Action) {
        if let user = self.users.first {
            for view in self.view.subviews {
                if view.tag == user.id {
                    if let card = view as? CombineCardView {
                        var center: CGPoint
                        
                        switch action {
                        case .deslike:
                            center = CGPoint(x: card.center.x - self.view.bounds.width, y: card.center.y + 50)
                        case .like:
                            center = CGPoint(x: card.center.x + self.view.bounds.width, y: card.center.y + 50)
                        case .superLike:
                            center = CGPoint(x: card.center.x, y: card.center.y - self.view.bounds.height)
                        }
                        
                        
                        UIView.animate(withDuration: 0.4, animations: {
                            card.center = center
                            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
                            card.deslikeImageView.alpha = action == .deslike ? 1 : 0
                            card.likeImageView.alpha = action == .like ? 1  : 0
                            
                        }) { (_) in
                            
                            if action == .like || action == .superLike {
                                self.verifyMatch(user: user)
                            }
                            self.removeCard(card: card)
                        }
                    }
                }
            }
        }
    }
    
    func removeCard(card: UIView ) {
        card.removeFromSuperview()
        self.users = self.users.filter({(user) -> Bool in
            return user.id != card.tag
        })
    }
    
    @objc func onClickLike() {
        self.animateCard(rotationAngle: 0.4, action: .like)
    }
    
    @objc func onClickSuperlike() {
        self.animateCard(rotationAngle: 0, action: .superLike)
    }
    
    @objc func onClickDeslike() {
     animateCard(rotationAngle: 0.4, action: .deslike)
    }
    
    @objc func handleCardAnimation(_ gesture: UIPanGestureRecognizer) {
        if let card = gesture.view as? CombineCardView {
            let point = gesture.translation(in: view)
            let rotationAngle = point.x / view.bounds.width * 0.4
            
            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            if point.x > 0 {
                card.likeImageView.alpha = rotationAngle * 5
                card.deslikeImageView.alpha = 0
            } else {
                card.likeImageView.alpha = 0
                card.deslikeImageView.alpha = rotationAngle * 5 * -1
            }
            
            if gesture.state == .ended {
                
                if card.center.x > self.view.bounds.width + 50 {
                    self.animateCard(rotationAngle: rotationAngle, action: .like)
                    return
                }
                
                if card.center.x < -50 {
                    self.animateCard(rotationAngle: rotationAngle, action: .deslike)
                    return
                }
                
                UIView.animate(withDuration: 0.2) {
                    card.center = self.view.center
                    card.transform = .identity
                    card.likeImageView.alpha = 0
                    card.deslikeImageView.alpha = 0
                }
            }
        }
    }
 
}
