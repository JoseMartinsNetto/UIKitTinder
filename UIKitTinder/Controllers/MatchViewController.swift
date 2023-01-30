//
//  MatchViewController.swift
//  TinderUIClone
//
//  Created by Jose Martins on 10/10/20.
//

import UIKit

class MatchViewController: UIViewController, UITextFieldDelegate {
    var user: User? {
        didSet {
            if let user = user {
                photoImageView.image = UIImage(named: user.image)
                messageLabel.text = "\(user.name) curtiu você também!"
            }
        }
    }
    
    let photoImageView: UIImageView = .photoImageView()
    let likeImageView: UIImageView = .photoImageView(named: "icone-like")
    let messageLabel: UILabel = .textBoldLabel(18, textColor: .white, alignment: .center)
    let sendMessageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Enviar", for: .normal)
        button.setTitleColor(UIColor(red: 62/255, green: 163/255, blue: 255/255, alpha: 1), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Voltar para o tinder", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    
    let messageField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.placeholder = "Diga algo legal..."
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.textColor = .darkText
        textField.returnKeyType = .go
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.rightViewMode = .always
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(photoImageView)
        photoImageView.fillWithSuperView()
        
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        photoImageView.layer.addSublayer(gradient)
        
        messageField.delegate = self
        messageField.addSubview(sendMessageButton)
        
        sendMessageButton.fill(
            top: messageField.topAnchor,
            leading: nil,
            bottom: messageField.bottomAnchor,
            trailing: messageField.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 16)
        )
        
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        likeImageView.contentMode = .scaleAspectFit
        
        backButton.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
        sendMessageButton.addTarget(self, action: #selector(onClickSendMessage), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews:  [likeImageView, messageLabel, messageField, backButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        
        stackView.fill(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 32, bottom: 46, right: 32)
        )
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onClickSendMessage()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func onClickSendMessage() {
        if let message = self.messageField.text {
            print(message)
        }
    }
    
    @objc func onKeyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                UIView.animate(withDuration: duration) {
                    self.view.frame = CGRect(
                        x: UIScreen.main.bounds.origin.x,
                        y: UIScreen.main.bounds.origin.y,
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height - keyboardSize.height
                    )
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func onKeyboardHide(notification: NSNotification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.view.frame = UIScreen.main.bounds
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func onClickBack() {
        self.dismiss(animated: true, completion: nil)
    }
}
