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
    
    var workoutDuration = [String]()
    var beatsPerMinute = [String]()
    
    var vertical: Bool = true {
        didSet {
            if vertical {
                verticalBarChartView = BarChartView()
            } else {
                horizontalBarChartView = HorizontalBarChartView()
            }
        }
    }
    
    var delegate: GetChartData! {
        didSet {
            populateData()
            barChartSetup()
        }
    }
    
    func populateData() {
        workoutDuration = delegate.workoutDuration
        beatsPerMinute = delegate.beatsPerMinute
    }
    
    func barChartSetup() {
        self.backgroundColor = UIColor.white
        let barChartView = (vertical) ? verticalBarChartView! : horizontalBarChartView!
        
        self.addSubview(barChartView)
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        barChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        barChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        barChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        if vertical {
            setBarChart(dataPoints: workoutDuration, v: beatsPerMinute)
        } else {
            setBarChart(dataPoints: beatsPerMinute, v: workoutDuration)
        }
    }
    
    func setBarChart(dataPoints: [String], v: [String]) {
        let barChartView = (vertical) ? verticalBarChartView! : horizontalBarChartView!
        
        barChartView.noDataTextColor = UIColor.white
        barChartView.noDataText = "No data for the Chart."
        barChartView.backgroundColor = UIColor.white
        
        let values = (vertical) ? v : v.reversed()
        for i in 0..<dataPoints.count {
            dataEntry.append(BarChartDataEntry(x: Double(i), y: Double(values[i])!))
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "BPM")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false)
        chartDataSet.colors = [UIColor.clerkieRed]
        
        // axes
        let formatter: ChartFormatter = ChartFormatter()
        if vertical {
            formatter.setValues(values: dataPoints)
        } else {
            formatter.setValues(values: dataPoints.reversed())
        }
        
        let xAxis = XAxis()
        xAxis.valueFormatter = formatter
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.valueFormatter = xAxis.valueFormatter
        barChartView.chartDescription?.enabled = false
        barChartView.legend.enabled = true
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = true
        barChartView.data = chartData
    }
}
