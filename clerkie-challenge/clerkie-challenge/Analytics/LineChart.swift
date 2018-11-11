//
//  LineChart.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/10/18.
//

import UIKit
import Charts

class LineChart: UIView {
    
    let lineChartView = LineChartView()
    
    var dataPoints = [String]()
    var values = [String : [String]]()
    
    var colors: [UIColor] = [UIColor.clerkieRed, UIColor.black, UIColor.lightGray]
    
    func populateData(dataPoints: [String], v: [String : [String]]) {
        self.dataPoints = dataPoints
        self.values = v
    }
    
    func setLineChart() {
        backgroundColor = UIColor.white
        
        let chartView = lineChartView
        
        self.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        chartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        chartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        chartView.animate(yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        setLineChartData()
    }
    
    func setLineChartData() {
        let chartView = lineChartView
        
        chartView.noDataTextColor = UIColor.white
        chartView.noDataText = "No data for the Chart."
        chartView.backgroundColor = UIColor.white
        
        var dataSets = [LineChartDataSet]()
        
        var i = 0
        for (label, v) in self.values {
            var dataEntry = [ChartDataEntry]()
            for i in 0..<dataPoints.count {
                dataEntry.append(ChartDataEntry(x: Double(i), y: Double(v[i])!))
            }
            
            let dataSet = LineChartDataSet(values: dataEntry, label: label)
            dataSet.circleRadius = 4.0
            let color = self.colors[i]
            dataSet.colors = [color]
            dataSet.setCircleColor(color)
            dataSet.circleHoleColor = color
            dataSet.fillAlpha = 65 / 255.0
            dataSet.fillColor = color.withAlphaComponent(200 / 255.0)
            dataSet.drawFilledEnabled = true
            
            dataSets.append(dataSet)
            i += 1
        }
        
        let chartData = LineChartData(dataSets: dataSets)
        chartData.setDrawValues(false)
        
        let formatter: ChartFormatter = ChartFormatter()
        formatter.setValues(values: dataPoints)
        
        let xAxis = XAxis()
        xAxis.valueFormatter = formatter
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.valueFormatter = xAxis.valueFormatter
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = true
        chartView.rightAxis.enabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawLabelsEnabled = true
        chartView.data = chartData
    }
}
