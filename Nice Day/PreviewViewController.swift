//
//  PreviewViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 03/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import Lottie
class PreviewViewController: UIViewController {
    let label: UILabel = {
        let label = HelloLabel()
        return label
    }()
    let animationView = AnimationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let animation = Animation.named("file")
        animationView.animation = animation
        animationView.frame = CGRect(x: 100, y: 200, width: 200, height: 200)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.5
        view.addSubview(animationView)
        view.addSubview(label)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        animationView.play(fromProgress: 0.2, toProgress: 1.0, loopMode: nil, completion: nil)
    }

}
