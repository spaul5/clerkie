//
//  BarChart.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/10/18.
//

import UIKit
import Charts

/// from Felicity Johnson's medium aticle
/// https://medium.com/@felicity.johnson.mail/lets-make-some-charts-ios-charts-5b8e42c20bc9
/// I converted her bar chart so I could use the same class to make a horizontal bar chart as well

class BarChart: UIView {
    
    var verticalBarChartView: BarChartView!
    var horizontalBarChartView: HorizontalBarChartView!
    
    var dataEntry: [BarChartDataEntry] = []
    
    var dataPoints = [String]()
    var values = [String]()
    
    var vertical: Bool = true {
        didSet {
            if vertical {
                verticalBarChartView = BarChartView()
            } else {
                horizontalBarChartView = HorizontalBarChartView()
            }
        }
    }
    
    func populateData(dataPoints: [String], v: [String]) {
        self.dataPoints = dataPoints
        self.values = v
    }
    
    func setBarChart() {
        self.backgroundColor = UIColor.white
        let chartView = (vertical) ? verticalBarChartView! : horizontalBarChartView!
        
        self.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        chartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        chartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        setBarChartData()
    }
    
    func setBarChartData() {
        let chartView = (vertical) ? verticalBarChartView! : horizontalBarChartView!
        
        chartView.noDataTextColor = UIColor.white
        chartView.noDataText = "No data for the Chart."
        chartView.backgroundColor = UIColor.white
        
        let v = (vertical) ? self.values : self.values.reversed()
        for i in 0..<dataPoints.count {
            dataEntry.append(BarChartDataEntry(x: Double(i), y: Double(v[i])!))
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "Heart Beats per Minute during a Workout")
        chartDataSet.colors = [UIColor.clerkieRed]
        
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
        chartData.barWidth = 0.5
        
        // axes
        let formatter: ChartFormatter = ChartFormatter()
        let d = (vertical) ? self.dataPoints : self.dataPoints.reversed()
        formatter.setValues(values: d)
        
        let xAxis = XAxis()
        xAxis.valueFormatter = formatter
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.valueFormatter = xAxis.valueFormatter
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = true
        chartView.rightAxis.enabled = false
        chartView.leftAxis.spaceBottom = 0.65
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawLabelsEnabled = true
        chartView.data = chartData
        chartView.drawValueAboveBarEnabled = true
    }
}
