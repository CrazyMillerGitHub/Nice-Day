//
//  OnboardingPresenter.swift
//  Nice Day
//
//  Created by Михаил Борисов on 29.07.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import Lottie

protocol OnboardingCallable where Self: UIViewController {

    var loginButton: ElasticButton { get }
    var newUserLabel: UILabel { get }
    func setPageControlProgress(_ value: Double)

}

final class OnboardingPresenter: NSObject {

    private weak var delegate: OnboardingCallable?
    private let scrollView: UIScrollView
    private let animationView: AnimationView
    private let titles: [String] = {
        ["_daly_activity".localized(),
         "_earn_xp".localized(),
         "_be_better".localized()]
    }()

    init(scrollView: UIScrollView, delegate: OnboardingCallable, animationView: AnimationView) {
        self.delegate = delegate
        self.scrollView = scrollView
        self.animationView = animationView
        super.init()
        configureSrollView()
    }

    private func configureLabel(idx: Int, title: String, contentView: UIView) -> UILabel {
        return UILabel().with { label in
            label.frame = CGRect(x: 30 + CGFloat(idx) * contentView.frame.size.width , y: 0, width: contentView.frame.width - 60, height: 19)
            label.textAlignment = .left
            label.text = title
            label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
            label.textColor = UIColor.inverseColor.withAlphaComponent(0.9)
        }
    }

    private func configureSrollView() {
        guard let contentView = delegate?.view else { return }
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: contentView.frame.size.width * 3, height: scrollView.frame.size.height)
        for (idx, title) in titles.enumerated() {
            scrollView.addSubview(configureLabel(idx: idx, title: title, contentView: contentView))
        }
        delegate?.view.bringSubviewToFront(scrollView)
    }
}

extension OnboardingPresenter: UIScrollViewDelegate {

    private func handlePan(recognizer: UIPanGestureRecognizer) {
        guard delegate != nil else { return }
        let translation = recognizer.translation(in: delegate?.view)
        let progress = translation.x / delegate!.view.bounds.size.width * 0.75
        animationView.currentProgress = progress
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.contentSize.width * 0.75 + 0.5
        delegate?.setPageControlProgress(Double(scrollView.contentOffset.x / scrollView.contentSize.width) * 3)
        guard !(progress < 0.5 || progress > 1) else { return }
        if let delegate = delegate, progress == 1.0, delegate.loginButton.isHidden {
            self.delegate?.loginButton.isHidden.toggle()
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.0, options: [.curveEaseOut], animations: { [weak self] in
                self?.delegate?.loginButton.alpha = 1.0
                self?.delegate?.newUserLabel.alpha = 1.0
            })
        }
        animationView.currentProgress = progress
    }
}
