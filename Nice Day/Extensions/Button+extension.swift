//
//  button+extension.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import AuthenticationServices

class ElasticButton: UIButton {
    override open var isHighlighted: Bool {
           didSet {
               if self.isHighlighted {
                   UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                       self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                   }, completion: nil)
               } else {
                   UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                       self.transform = .identity
                   }, completion: nil)
               }
           }
       }
    
}

@objc class ClosureSleeve: NSObject {
    let closure: () -> Void

    init (_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIButton {
    
    static var signIn: UIButton {
        // inizialization button
        let button = UIButton()
        // set clear background color
        button.backgroundColor = .clear
        button.tintColor = .white
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        // set title font to SF semibold size - 17.0
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        // disable auto constraint
        button.translatesAutoresizingMaskIntoConstraints = false
        // hide button
        button.alpha = 0
        // set corner radius
        button.layer.cornerRadius = 15
        // set clips to bound to true
        button.clipsToBounds = true
        // add target to signIn Button
        return button
    }
    
    static var emailSignIn: UIButton {
        // inizialization button
        let button = ElasticButton()
        // set background color
        button.backgroundColor = UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0)
        // set title to localized
        button.setTitle("_sign_in_with_email_and_password".localized, for: .normal)
        // set tint color to white
        button.tintColor = .white
        // set font to SF semibold size - 18
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        // disable auto constraint
        button.translatesAutoresizingMaskIntoConstraints = false
        // set corner radius to 5 pt
        button.layer.cornerRadius = 5
        // set clips to bounds to true
        button.clipsToBounds = true
        return button
    }
    
    static var appleSignIn: (_ type: ASAuthorizationAppleIDButton.ButtonType, _ style: ASAuthorizationAppleIDButton.Style) -> ASAuthorizationAppleIDButton = { type, style in
        // inzialize sign in button
        let appleSignInButton = ASAuthorizationAppleIDButton(type: type, style: style)
        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        return appleSignInButton
    }
    
}
