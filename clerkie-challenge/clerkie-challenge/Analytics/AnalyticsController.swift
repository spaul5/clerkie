//
//  AnalyticsController.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/10/18.
//

import UIKit
import Charts

class AnalyticsController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var barChartButton: UIButton!
    @IBOutlet weak var horizontalBarChartButton: UIButton!
    @IBOutlet weak var lineChartButton: UIButton!
    @IBOutlet weak var duoLineChart: UIButton!
    @IBOutlet weak var pieChartButton: UIButton!
    
    @IBOutlet weak var chartView: UIView!
    
    override func viewDidLoad() {
        print("analytics controller did load")
        
        backButton.isHidden = true
        backButton.setTitle("\u{3008}", for: .normal)
        
        barChartButton.layer.borderColor = UIColor.white.cgColor
        barChartButton.layer.borderWidth = 1.0
        
        horizontalBarChartButton.layer.borderColor = UIColor.white.cgColor
        horizontalBarChartButton.layer.borderWidth = 1.0
        
        lineChartButton.layer.borderColor = UIColor.white.cgColor
        lineChartButton.layer.borderWidth = 1.0
        
        duoLineChart.layer.borderColor = UIColor.white.cgColor
        duoLineChart.layer.borderWidth = 1.0
        
        pieChartButton.layer.borderColor = UIColor.white.cgColor
        pieChartButton.layer.borderWidth = 1.0
    }
    
    
    @IBAction func logoutTap(_ sender: Any) {
        Utilities.shared.logout()
    }
    
    @IBAction func backButtonTap(_ sender: Any) {
        print("back tap")
        mainTitle.text = "Analytics"
        backButton.isHidden = true
        showHideChartView(false)
        for v in chartView.subviews {
            v.removeFromSuperview()
        }
    }
    
    @IBAction func barChartTap(_ sender: Any) {
        print("vertical bar chart")
        switchButtons(sender)
        doBarChart()
    }
    
    @IBAction func horizontalBarChartTap(_ sender: Any) {
        switchButtons(sender)
        doBarChart(false)
    }
    
    @IBAction func lineChartTap(_ sender: Any) {
        switchButtons(sender)
        doLineChart()
    }
    
    @IBAction func douLineChartTap(_ sender: Any) {
        switchButtons(sender)
        doLineChart(true)
    }
    
    @IBAction func pieChartTap(_ sender: Any) {
        switchButtons(sender)
        doPieChart()
    }
    
    func doBarChart(_ vertical: Bool = true) {
        var dataPoints = [String]()
        for i in 1...10 { dataPoints.append(String(i)) }
        let values = ["76", "150", "160", "180", "195", "136", "195", "180", "164", "136"]
    
        let barChart = BarChart(frame: chartView.bounds)
        barChart.vertical = vertical
        barChart.populateData(dataPoints: dataPoints, v: values)
        barChart.setBarChart()
        showHideChartView(true)
        chartView.addSubview(barChart)
    }
    
    func doLineChart(_ duo: Bool = false) {
        var dataPoints = [String]()
        var shouvikValues = [String]()
        for i in 1...12 { dataPoints.append(String(i)); shouvikValues.append(String(i * i)); }
        var values = ["Clerkie's growth with Shouvik" : shouvikValues ]
        
        if duo {
            values["Clerkie's growth without Shouvik"] = ["1", "1.5", "2", "5", "10", "16", "27", "33", "47", "51", "55", "59"]
        }
        
        let lineChart = LineChart(frame: chartView.bounds)
        lineChart.populateData(dataPoints: dataPoints, v: values)
        lineChart.setLineChart()
        showHideChartView(true)
        chartView.addSubview(lineChart)
    }
    
    func doPieChart() {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = ["20", "4", "6", "3", "12", "16"]
        
        let pieChart = PieChart(frame: chartView.bounds)
        pieChart.populateData(dataPoints: months, v: unitsSold)
        pieChart.setPieChart()
        showHideChartView(true)
        chartView.addSubview(pieChart)
    }
    
    func showHideChartView(_ show: Bool) {
        if show {
            chartView.isHidden = false
            UIView.animate(withDuration: 0.25) {
                self.chartView.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.chartView.alpha = 0.0
            }) { _ in
                self.chartView.isHidden = true
            }
        }
    }
    
    func switchButtons(_ sender: Any) {
        mainTitle.text = (sender as! UIButton).title(for: .normal)
        backButton.isHidden = false
    }
}

public class ChartFormatter: NSObject, IAxisValueFormatter {
    var dataPoints = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dataPoints[Int(value)]
    }
    
    public func setValues(values: [String]) {
        self.dataPoints = values
    }
}
