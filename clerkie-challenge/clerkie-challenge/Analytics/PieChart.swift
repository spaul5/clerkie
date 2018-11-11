//
//  PieChart.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/10/18.
//

import UIKit
import Charts

class PieChart: UIView {
    
    let pieChartView = PieChartView()
    var dataEntry: [ChartDataEntry] = []
    
    var dataPoints = [String]()
    var values = [String]()
    
    var colors = [UIColor]()
    
    func populateData(dataPoints: [String], v: [String]) {
        self.dataPoints = dataPoints
        self.values = v
    }
    
    func setPieChart() {
        backgroundColor = UIColor.white
        let chartView = pieChartView
        
        self.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        chartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        chartView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        chartView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutBack)
        
        setPieChartData()
    }
    
    
    func setPieChartData() {
        var dataEntries: [PieChartDataEntry] = []
        for i in 0..<dataPoints.count {
            dataEntries.append(PieChartDataEntry(value: Double(values[i])!, label: dataPoints[i]))
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        let chartView = pieChartView
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
        pieChartDataSet.colors = colors
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        chartView.data = pieChartData
        chartView.drawEntryLabelsEnabled = true
        
    }
}
