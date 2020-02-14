//
//  extension+stackView.swift
//  Stack_test
//
//  Created by Михаил Борисов on 09.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

extension UIStackView {

    // MARK: ContainerStackView
    static var container: UIStackView {
        // inizialization stackView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        // setted distributon to equal spacing
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        // hide stackView
        stackView.alpha = 0
        // setted to perform constraints later
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

}
