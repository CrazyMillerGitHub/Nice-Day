//
//  BunusCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class BonusCell: CoreCell {

    typealias DataType = String

    static var identifier: String = String(describing: BonusCell.self)

    weak var timer: Timer?
    
    private let timeTitle = UILabel().with { label in
        label.textAlignment = .center
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(timeTitle)

        inizializeTimer()
        prepareUI()
        refresh()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(data: String) {
        self.cellTitleLabel.text = data
    }

    private func inizializeTimer() {
        if timer == nil {
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            self.timer = timer
        }
    }

    private func prepareUI() {
        // inizializing constraints
        NSLayoutConstraint.activate([
            timeTitle.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            timeTitle.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            timeTitle.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    // MARK: Neeed to reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        refresh()
    }

    private func refresh() {
        setTimer()
    }

    // MARK: - Timer until next Monday
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
            let formatString : String = NSLocalizedString("_day_count", comment: "")
            let days = String.localizedStringWithFormat(formatString, day)
            return ("\(isWeekend ? "Bonus" : "_wait".localized): \(days) \(String(format: "%02d:%02d:%02d", hour, minute, second))", isWeekend)
        }
        return ("", false)
    }
    
    @objc
    private func setTimer() {
        let date = timeUntilNextMonday()
        timeTitle.text = date.message
        timeTitle.adjustsFontSizeToFitWidth = true
        contentView.backgroundColor = date.isWeekend ? .secondGradientColor : .sunriseColor
    }
    
}
