//
//  AnimatedLabel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 22.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

enum CountingMethod {
    case easeInOut, easeIn, easeOut, linear
}

enum AnimationDuration {
    case laborious, plodding, strolling, brisk, noAnimation

    var value: TimeInterval {
        switch self {
        case .laborious: return 20.0
        case .plodding: return 15.0
        case .strolling: return 8.0
        case .brisk: return 2.0
        case .noAnimation: return 0.0
        }
    }
}

enum DecimalPoints {
    case zero, one, two, ridiculous

    var format: String {
        switch self {
        case .zero: return "%.0f"
        case .one: return "%.1f"
        case .two: return "%.2f"
        case .ridiculous: return "%f"
        }
    }
}

final class AnimatedLabel: UILabel {
    typealias OptionalCallback = (() -> Void)
    typealias OptionalFormatBlock = (() -> String)

    var completion: OptionalCallback?
    var animationDuration: AnimationDuration = .brisk
    var decimalPoints: DecimalPoints = .zero
    var countingMethod: CountingMethod = .easeInOut
    var customFormatBlock: OptionalFormatBlock?

    private var currentValue: Float {
        if progress >= totalTime { return destinationValue }
        var value = Float(progress / totalTime) * (destinationValue - startingValue)
        return startingValue + update(value: &value)
    }

    private var rate: Float = 0
    private var startingValue: Float = 0
    private var destinationValue: Float = 0
    private var progress: TimeInterval = 0
    private var lastUpdate: TimeInterval = 0
    private var totalTime: TimeInterval = 0
    private var easingRate: Float = 0
    private var timer: CADisplayLink?

    func count(from: Float, toValue: Float, duration: AnimationDuration = .strolling) {
        startingValue = from
        destinationValue = toValue
        timer?.invalidate()
        timer = nil

        if duration.value == 0.0 {
            setTextValue(value: toValue)
            completion?()
            return
        }

        easingRate = 3.0
        progress = 0.0
        totalTime = duration.value
        lastUpdate = Date.timeIntervalSinceReferenceDate
        rate = 3.0

        addDisplayLink()
    }

    func countFromCurrent(toValue: Float, duration: AnimationDuration = .strolling) {
        count(from: currentValue, toValue: toValue, duration: duration)
    }

    func countFromZero(toValue: Float, duration: AnimationDuration = .strolling) {
        count(from: 0, toValue: toValue, duration: duration)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        progress = totalTime
        completion?()
    }

    private func addDisplayLink() {
        timer = CADisplayLink(target: self, selector: #selector(self.updateValue(timer:)))
        timer?.add(to: .main, forMode: .default)
        timer?.add(to: .main, forMode: .tracking)
    }

    private func update(value: inout Float) -> Float {
        switch countingMethod {
        case .linear:
            return value
        case .easeIn:
            return powf(value, rate)
        case .easeInOut:
            var sign: Float = 1
            if Int(rate) % 2 == 0 { sign = -1 }
            value *= 2
            return value < 1 ? 0.5 * powf(value, rate) : (sign*0.5) * (powf(value-2, rate) + sign*2)
        case .easeOut:
            return 1.0-powf((1.0-value), rate)
        }
    }

    @objc private func updateValue(timer: Timer) {
        let now: TimeInterval = Date.timeIntervalSinceReferenceDate
        progress += now - lastUpdate
        lastUpdate = now

        if progress >= totalTime {
            self.timer?.invalidate()
            self.timer = nil
            progress = totalTime
        }

        setTextValue(value: currentValue)
        if progress == totalTime { completion?() }
    }

    private func setTextValue(value: Float) {
        text = String(format: customFormatBlock?() ?? decimalPoints.format, value)
    }

}
