//
//  AboutCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class AboutCell: UICollectionViewCell {
    
    static var identifier = "about"
    
    var headerView: ProfileHeaderView!
    
    //  создание imageView
      let imageView: UIImageView = {
             let imageView = UIImageView()
          imageView.layer.cornerRadius = 45.5
             imageView.translatesAutoresizingMaskIntoConstraints = false
             imageView.clipsToBounds = true
             imageView.contentMode = .scaleAspectFit
             imageView.backgroundColor = .red
             return imageView
         }()

       // MARK: SignOut Button
       let signOutButton: UIButton = {
           let button = UIButton()
           button.backgroundColor = .sunriseColor
           button.translatesAutoresizingMaskIntoConstraints = false
           button.layer.cornerRadius = 15
           button.clipsToBounds = true
           button.setTitle("_signOut".localized(), for: .normal)
           button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
           return button
       }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        signOutButton.addTarget(self, action: #selector(signOutAction), for: .touchUpInside)
        let headerView = ProfileHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(headerView)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(signOutButton)
        self.headerView = headerView
        
        NSLayoutConstraint.activate([
            
            self.headerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 35.0),
            
            self.imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 116),
            self.imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 91.0),
            self.imageView.heightAnchor.constraint(equalToConstant: 91.0),
                   
                   //SignOutButtonConstraints
            self.signOutButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            self.signOutButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.signOutButton.heightAnchor.constraint(equalToConstant: 46),
            self.signOutButton.widthAnchor.constraint(equalToConstant: 143)
            
        ])
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private func reset() {
        self.contentView.backgroundColor = .bgColor
    }
    
    @objc
    private func signOutAction() {
         UserDefaults.standard.set(false, forKey: "loggedIn")

    }
}

class ProfileHeaderView: UIView {

    override func draw(_ rect: CGRect) {
        ProfileHeader.drawCanvas1(frame: self.bounds, resizing: .aspectFill)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView() {
        self.backgroundColor = .clear
    }
}

public class ProfileHeader : NSObject {

    //// Drawing Methods

    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 375, height: 35), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 375, height: 35), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 375, y: resizedFrame.height / 35)

        //// Color Declarations
        let fillColor = UIColor(red: 0.996, green: 0.180, blue: 0.333, alpha: 1.000)

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 23.83))
        bezierPath.addLine(to: CGPoint(x: 0, y: 12.65))
        bezierPath.addCurve(to: CGPoint(x: 55, y: 5), controlPoint1: CGPoint(x: 15.46, y: 7.84), controlPoint2: CGPoint(x: 34.46, y: 5))
        bezierPath.addCurve(to: CGPoint(x: 123, y: 17.54), controlPoint1: CGPoint(x: 81.75, y: 5), controlPoint2: CGPoint(x: 105.88, y: 9.81))
        bezierPath.addCurve(to: CGPoint(x: 191, y: 5), controlPoint1: CGPoint(x: 140.12, y: 9.81), controlPoint2: CGPoint(x: 164.25, y: 5))
        bezierPath.addCurve(to: CGPoint(x: 255.5, y: 16.04), controlPoint1: CGPoint(x: 215.97, y: 5), controlPoint2: CGPoint(x: 238.67, y: 9.19))
        bezierPath.addCurve(to: CGPoint(x: 320, y: 5), controlPoint1: CGPoint(x: 272.33, y: 9.19), controlPoint2: CGPoint(x: 295.03, y: 5))
        bezierPath.addCurve(to: CGPoint(x: 375, y: 12.65), controlPoint1: CGPoint(x: 340.54, y: 5), controlPoint2: CGPoint(x: 359.54, y: 7.84))
        bezierPath.addLine(to: CGPoint(x: 375, y: 23.83))
        bezierPath.addLine(to: CGPoint(x: 375, y: 35))
        bezierPath.addLine(to: CGPoint(x: 0, y: 35))
        bezierPath.addLine(to: CGPoint(x: 0, y: 23.83))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        fillColor.setFill()
        bezierPath.fill()
        
        context.restoreGState()

    }

    @objc(ProfileHeaderResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
