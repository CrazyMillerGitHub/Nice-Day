//
//  BunusCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class BonusCell: CoreCell {
    
    static var identifier: String = "bonus"

    weak var timer: Timer?
    
    private let timeTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wait: 23:59:59"
        label.textColor = .white
        return label
    }()
    
    var item: MainViewModelItem? {
        didSet {
            guard let item = item as? BonusCellModelItem else { return }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .sunriseColor
        self.contentView.addSubview(timeTitle)
        NSLayoutConstraint.activate([
            
            timeTitle.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            timeTitle.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            timeTitle.heightAnchor.constraint(equalToConstant: 46)
            
        ])
        if timer == nil {
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            self.timer = timer
        }
        
        refresh()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        refresh()
    }
    
    private func refresh() {
        fireTimer()
    }
    
    private func timeUntilNextMonday() -> (message:String, isWeekend: Bool) {
        let date = Date()
        var nextMonday: Date {
            
            let nextMonday = Calendar.current.dateComponents([.day, .month, .year], from: date.next(.monday))
            
            if let day = nextMonday.day,
               let month = nextMonday.month,
               let year = nextMonday.year {
                let dataComponents = DateComponents(calendar: Calendar.current, year: year, month: month, day: day, hour: 0, minute: 0, second: 0, nanosecond: 0)
                return Calendar.current.date(from: dataComponents) ?? Date()
            }
            
            return Date()
        }
        let timeInterval = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date, to: nextMonday)
        if let day = timeInterval.day,
           let hour = timeInterval.hour,
           let minute = timeInterval.minute,
           let second = timeInterval.second {
            let isWeekend = day < 2
            return ("\(isWeekend ? "Bonus" : "Wait"):\(String(hour).count > 1 ? "" : "0")\(hour):\(String(minute).count > 1 ? "" : "0")\(minute):\(String(second).count > 1 ? "" : "0")\(second)",isWeekend)
        }
        return ("",false)
    }
    
    @objc
    private func fireTimer() {
        let date = timeUntilNextMonday()
        self.timeTitle.text = date.message
        self.contentView.backgroundColor = date.isWeekend ? .secondGradientColor : .sunriseColor
    }
    
}
