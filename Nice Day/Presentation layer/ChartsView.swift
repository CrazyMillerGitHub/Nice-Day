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
    init() {
        super.init(frame: .zero)
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
        self.legend.form = .rectangle
        self.legend.formSize = 10.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLine(data: [Int], color: UIColor, label: String = "Yeys") {
        var chartEntry = [ChartDataEntry]()
        data.forEach {
            let value = ChartDataEntry(x: Double($0), y: Double.random(in: 0...100))
            chartEntry.append(value)
        }
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
class ChartsViewController: UIViewController {
    
    let charts: ChartsView = {
        let charts = ChartsView()
        charts.addLine(data: Array(0...10), color: .red)
        charts.addLine(data: Array(0...10), color: .blue)
        return charts
    }()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        charts.frame = view.frame
        self.view.addSubview(charts)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}