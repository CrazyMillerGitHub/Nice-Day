//
//  ProfileViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 16/09/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        imageView.widthAnchor.constraint(equalToConstant: 60.0),
        imageView.heightAnchor.constraint(equalToConstant: 60.0)])
        
    }
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private func setupView() {
        bgView()
        setupImageView()
    }
    
    private func bgView() {
        self.view.backgroundColor = .black
        let bgView = UIView(frame: self.view.frame)
        bgView.backgroundColor = .bgColor
        bgView.layer.cornerRadius = 5
        self.view.addSubview(bgView)
    }
    
    private func setupImageView() {
        self.view.addSubview(imageView)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
