//
//  chart.swift
//  bluetap
//
//  Created by Nicha Thongtanakul on 4/12/19.
//  Copyright © 2019 Nicha Thongtanakul. All rights reserved.
//

import UIKit
import Charts

class Chart: UIViewController {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var decorButton1: UIButton!
    @IBOutlet weak var chtChart: LineChartView!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var yAxisLabel: UILabel!
    
    var status: Model.gameState = .over
    var formatter = DateFormatter()
    
    override func viewDidLoad() {
        
        decorButton1.setImage(UIImage(named: "mark-x"), for: .normal)
        
        yAxisLabel.transform = CGAffineTransform(rotationAngle: -3.14/2)
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: "2019/12/01")
        Model.defaults.set(someDateTime, forKey: "startDate")
        if (Model.defaults.object(forKey: "highscore") == nil) {
            Model.defaults.set(0, forKey: "highscore")
            Model.defaults.set(Date(), forKey: "startDate")
        }
        highscoreLabel.text = "Highscore: \(Model.defaults.integer(forKey: "highscore"))"
        
        updateGraph()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! ViewController
        vc.game.status = Model.gameState.play
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
    }
    
    func updateGraph(){
        
        var lineChartEntry = [ChartDataEntry]()
        var dates = [String]()

        if (Model.defaults.dictionaryRepresentation().count == 12) {
            progressLabel.text = "We'll track your progress here, good luck! :)"
        } else {
            for (key, value) in Model.defaults.dictionaryRepresentation() {
                
                if (key.count == 10) {
                    let start1 = key.index(key.startIndex, offsetBy: 4)
                    let end1 = key.index(key.startIndex, offsetBy: 5)
                    
                    let range1 = start1..<end1
                    
                    let start2 = key.index(key.startIndex, offsetBy: 7)
                    let end2 = key.index(key.startIndex, offsetBy: 8)
                    
                    let range2 = start2..<end2
                    if (key[range1] == "-" && key[range2] == "-") {
                        let date = Date(key)
                        let startDate = Model.defaults.object(forKey: "startDate") as! Date
                        
                        let interval: Int = Int(date.timeIntervalSince(startDate) / (3600 * 24))
                        
                        let value = ChartDataEntry(x: Double(interval), y: value as! Double)
                        
                        lineChartEntry.append(value)
                        
                    }
                }
            }
            
            lineChartEntry.sort(by: { $0.x < $1.x })

            for index in 1...lineChartEntry.count {
                dates.append(intToDateString(days: index))
            }
            let line1 = LineChartDataSet(entries: lineChartEntry)
            line1.colors = [UIColor.blue]
            
            let data = LineChartData()
            data.addDataSet(line1)
            chtChart.legend.enabled = false
            chtChart.data = data
            chtChart.dragXEnabled = true
            chtChart.xAxis.drawAxisLineEnabled = true
            chtChart.xAxis.drawGridLinesEnabled = true
            chtChart.xAxis.granularityEnabled = true
            chtChart.xAxis.granularity = 1.0
            chtChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
            chtChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
            chtChart.xAxis.labelRotationAngle = -90
            chtChart.extraBottomOffset = 45
            progressLabel.text = "How have we been doing?"
        }
    }
    
    func intToDateString(days: Int) -> String{
        let daysToAdd = days - 1
        let startDate = Model.defaults.object(forKey: "startDate") as! Date
        let newDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: startDate)
        return formatter.string(from: newDate!)
    }
}

extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval: 0, since: date)
    }
}

