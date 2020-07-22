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
    
    private var lines: [LineChartDataSet] = []
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    init() {
        super.init(frame: .zero)
        axisFormatDelegate = self
        self.xAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
        self.scaleXEnabled = false
        self.scaleYEnabled =  false
        self.rightAxis.enabled = true
        self.leftAxis.enabled = false
        self.xAxis.labelTextColor = UIColor.inverseColor.withAlphaComponent(0.6)
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
        self.xAxis.valueFormatter = axisFormatDelegate
        self.xAxis.forceLabelsEnabled = true
        self.legend.form = .rectangle
        self.legend.textColor = .inverseColor
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

    func addLine(data: [Double: [Usage]], color: UIColor, label: String) {

        var chartEntry = [ChartDataEntry]()

        let arr = Array(data).sorted { (lhs, rhs) -> Bool in
            return lhs.key < rhs.key
        }

        for (key, value) in arr {
            let total: Double = Double(value.compactMap { $0.total }.reduce(0, +))
            let value = ChartDataEntry(x: key, y: total)
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
        reloadChart(items: arr.count)
    }
    
    private func reloadChart(items: Int) {
        let data = LineChartData(dataSets: lines)
        xAxis.labelCount = items
        xAxis.forceLabelsEnabled = true
        notifyDataSetChanged()
        self.data = data
    }
}

extension ChartsView: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let arr = Calendar.current.shortStandaloneWeekdaySymbols.map { $0.capitalized }
        return arr[(Int(value) % 10) % 7]
    }

}
