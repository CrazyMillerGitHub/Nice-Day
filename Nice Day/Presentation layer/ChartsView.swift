//
//  ChartsView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 15.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import Charts

class ChartsView: LineChartView {
    
    fileprivate var lines: [LineChartDataSet] = []
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    init() {
        super.init(frame: .zero)
        axisFormatDelegate = self
        self.xAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
        self.scaleXEnabled = false
        self.scaleYEnabled =  false
        self.rightAxis.enabled = false
        self.leftAxis.enabled = false
        self.xAxis.labelTextColor = UIColor.black.withAlphaComponent(0.6)
        self.leftAxis.drawGridLinesEnabled = false
        self.xAxis.avoidFirstLastClippingEnabled = true
        self.rightAxis.enabled = false
        self.xAxis.granularityEnabled = true
        self.xAxis.granularity = 1
        self.xAxis.drawAxisLineEnabled = false
        self.pinchZoomEnabled = false
        self.doubleTapToZoomEnabled = false
        self.chartDescription?.text = ""
        self.leftAxis.axisMinimum = 0.0
        self.xAxis.axisMinimum = 0.0
        self.xAxis.valueFormatter = axisFormatDelegate
        self.legend.form = .rectangle
        self.legend.formSize = 10.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func isLegendHidden(_ label: String) {
        if label == "hidden" {
            self.legend.enabled = false
        }
    }
    
    func addLine(data: [Int], color: UIColor, label: String = "") {
        var chartEntry = [ChartDataEntry]()
        data.forEach {
            let value = ChartDataEntry(x: Double($0), y: Double.random(in: 0...100))
            chartEntry.append(value)
        }
        isLegendHidden(label)
        let line = LineChartDataSet(entries: chartEntry, label: label)
        line.colors = [color]
        line.drawCirclesEnabled = false
        line.drawFilledEnabled = true
        line.fillColor = color
        line.fillAlpha = 1.0
        line.mode = .cubicBezier
        line.drawValuesEnabled = false
        line.highlightEnabled = false
        lines.append(line)
        reloadChart()
    }
    
    private func reloadChart() {
        let data = LineChartData(dataSets: lines)
        self.data = data
    }
}

extension ChartsView: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let arr = ["Mon", "Wed", "Thu", "Wen", "Fri", "Sun", "Sat"]
        return arr[Int(value)]
    }
}
