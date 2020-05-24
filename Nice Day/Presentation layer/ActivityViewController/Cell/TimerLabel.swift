//
//  TimerLabel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06.01.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

class TimerLabel: UILabel {
    
    var timer: Timer?
    
    private var count = 0
    
    private var hours: Int {
        return count / 3600
    }
    
    private var minutes: Int {
        return count / 60 % 60
    }
    
    private var seconds: Int {
        return count % 60
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createTimer() {
        if timer == nil {
            let timer = Timer(timeInterval: 1.0,
                              target: self,
                              selector: #selector(updateTimer),
                              userInfo: nil,
                              repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            
            self.timer = timer
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        count = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [.curveEaseOut], animations: {
                self.transform = .identity
            }, completion: nil)
        })
        self.text = "00:00:00"
    }
    
    @objc
    private func updateTimer() {
        count += 1
        text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
