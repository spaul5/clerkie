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
    
    var workoutDuration = [String]()
    var beatsPerMinute = [String]()
    
    func getChartData(with dataPoints: [String], values: [String]) {
        print("get chart data")
        self.workoutDuration = dataPoints
        self.beatsPerMinute = values
    }
    
    
    @IBOutlet weak var chartView: UIView!
    
    override func viewDidLoad() {
        print("analytics controller did load")
        
        backButton.isHidden = true
        backButton.setTitle("\u{3008}", for: .normal)
    }
    
    @IBAction func backButtonTap(_ sender: Any) {
        print("back tap")
        mainTitle.text = "Analytics"
        backButton.isHidden = true
        for v in chartView.subviews {
            v.removeFromSuperview()
        }
        chartView.isHidden = true
        
        workoutDuration = [String]()
        beatsPerMinute = [String]()
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
    
    func doBarChart(_ vertical: Bool = true) {
        let dataPoints = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        let values = ["76", "150", "160", "180", "195", "136", "195", "180", "164", "136"]
    
        let barChart = BarChart(frame: chartView.bounds)
        barChart.vertical = vertical
        barChart.populateData(dataPoints: dataPoints, v: values)
        barChart.setBarChart()
        chartView.isHidden = false
        chartView.addSubview(barChart)
    }
    
    func doLineChart(_ duo: Bool = false) {
        let dataPoints = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        var values = ["Workout BPM" : ["76", "150", "160", "180", "195", "136", "195", "180", "164", "136"]]
        
        if duo {
            values["Restful BPM"] = ["60", "66", "74", "80", "72", "70", "68", "68", "64", "58"]
        }
        
        let lineChart = LineChart(frame: chartView.bounds)
        lineChart.populateData(dataPoints: dataPoints, v: values)
        lineChart.setLineChart()
        chartView.isHidden = false
        chartView.addSubview(lineChart)
    }
    
    func switchButtons(_ sender: Any) {
        mainTitle.text = (sender as! UIButton).title(for: .normal)
        backButton.isHidden = false
    }
}

public class ChartFormatter: NSObject, IAxisValueFormatter {
    var workoutDuration = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return workoutDuration[Int(value)]
    }
    
    public func setValues(values: [String]) {
        self.workoutDuration = values
    }
}
