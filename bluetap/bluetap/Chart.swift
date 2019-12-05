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
    @IBOutlet weak var chtChart: LineChartView!
    @IBOutlet weak var highscoreLabel: UILabel!
    var status: Model.gameState = .over
    
    override func viewDidLoad() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: "2019/12/01")
        Model.defaults.set(someDateTime, forKey: "startDate")
        formatter.dateFormat = "yyyy-MM-dd"
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
//                let formatter = DateFormatter()
//                formatter.dateStyle = .short
//                formatter.timeStyle = .none
//                formatter.locale = Locale.current
                //let xValuesNumberFormatter = ChartXAxisFormatter( dateFormatter: formatter)
                let date = Date(key)
                let startDate = Model.defaults.object(forKey: "startDate") as! Date
                
                let interval: Int = Int(date.timeIntervalSince(startDate) / (3600 * 24))

                let value = ChartDataEntry(x: Double(interval), y: value as! Double)
                    
                    print(value)
                    lineChartEntry.append(value)
            }
            }
            }

            print(lineChartEntry)
            lineChartEntry.sort(by: { $0.x < $1.x })
            let line1 = LineChartDataSet(entries: lineChartEntry)
            line1.colors = [UIColor.blue]
            
            let data = LineChartData()
            data.addDataSet(line1)
            chtChart.legend.enabled = false
            chtChart.data = data
            chtChart.dragXEnabled = true
            

            progressLabel.text = "How have we been doing?"
        }
    }
    
//    func intToDateString(days: Int) -> String{
//        let daysToAdd = days
//        let startDate = Model.defaults.object(forKey: "startDate") as! Date
//        let newDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: startDate)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: newDate!)
//    }
}
    
extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}

//class ChartXAxisFormatter: NSObject {
//    fileprivate var dateFormatter: DateFormatter?
//
//    convenience init(dateFormatter: DateFormatter) {
//        self.init()
//        self.dateFormatter = dateFormatter
//    }
//}
//
//
//extension ChartXAxisFormatter: IAxisValueFormatter {
//
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        let daysToAdd = value
//        let startDate = Model.defaults.object(forKey: "startDate") as! Date
//        let newDate = Calendar.current.date(byAdding: .day, value: Int(daysToAdd), to: startDate)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: newDate!)
//    }
//
//}

//class MyCustomBottomAxisFormatter: NSObject, IAxisValueFormatter {
//    private var scores: [MyScoreObject]?
//
//    lazy private var dateFormatter: DateFormatter = {
//
//        return dateFormatter
//    }()
//
//    convenience init(usingScores scores: [MyScoreObject]) {
//        self.init()
//        self.scores = scores
//    }
//
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        let index = Int(value)
//
//        guard let scores = scores, index < scores.count, let date = scores[index].date else {
//            return "?"
//        }
//
//        return dateFormatter.string(from: date)
//    }
//}
