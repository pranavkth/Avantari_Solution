//
//  ViewController.swift
//  Avantari_Assignment
//  Created by pranav gupta on 05/05/17.
//  Copyright © 2017 Pranav gupta. All rights reserved.


import UIKit
import SocketIO
import UserNotifications
import Charts


class ChartViewController: UIViewController, ChartViewDelegate {
    
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var splineChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splineChart.delegate = self
        loadPersistentData()
        socketFunctionality()
    }
    
    func socketFunctionality(){
        
        socket.on("connect") { dataArray, ack in
            print("connected")
        }
        
        socket.on("capture") {
            
            dataArray,ack in
            
            let numberGenerated = dataArray[0] as! Int
            
            // Filter numbers such as 0<number<=9.
            
            if numberGenerated > 0 , numberGenerated < 10 {
                
                
                let date = Date()
                let calendar = Calendar.current
                let hour =  calendar.component(.hour, from: date)
                let minute = calendar.component(.minute,from: date)
                let seconds = calendar.component(.second, from: date)
                let time = String(hour) + ":" + String(minute) + ":" + String(seconds)
                
                let persistentDataObject = ServerData(time: time, number: numberGenerated)
                
                var chartData = [ChartDataEntry]()
                
                persistentDataGlobal.append(persistentDataObject)
                
                if data.count == 10 {
                    data.remove(at: 0)
                }
                
                data.append(numberGenerated)
                
                // Create dataEntryObjectArray to pass to chart.
                
                for i in 0..<data.count{
                    
                    let chartDataEntry = ChartDataEntry(x: Double(i+1), y: Double(data[i]))
                    chartData.append(chartDataEntry)
                    
                }
                
                // Reload Chart.
                
                self.setChart(chartData: chartData)
                
                
                // Compare to schedule notfication.
                
                if data.count == 2 , data[0] == data[1] {
                    
                    delegate?.scheduleNotification(at: date)
                    
                }
                
                
                if data.count > 2 , numberGenerated == data[data.count - 2]  {
                    
                    delegate?.scheduleNotification(at: date)
                }
                
            }
            
        }
        
    }
    
    // Function to  configure and display chart.
    
    func setChart(chartData:[ChartDataEntry]) {
        
        let splineChartData = LineChartData()
        let dataset = LineChartDataSet(values: chartData, label: "SplineChart")
        dataset.colors = [NSUIColor.red]
        dataset.drawCirclesEnabled = true
        dataset.circleHoleColor = UIColor.white
        dataset.circleRadius = 6.0
        dataset.fillAlpha = 65/255.0
        dataset.axisDependency = .left
        
        // To make Line Chart display as spline chart.
        
        dataset.mode = .cubicBezier
        splineChartData.addDataSet(dataset)
        self.splineChart.data = splineChartData
        self.numberLabel.text = String(data[data.count - 1])
        self.splineChart.gridBackgroundColor = NSUIColor.white
        self.splineChart.xAxis.drawGridLinesEnabled = true;
        self.splineChart.chartDescription?.text = "Avantari_Assignment_Pranav"
    }
    
    // Function to Load Persistent Data.
    
    func loadPersistentData(){
        
        if persistentDataGlobal.count != 0{
            
            
            if persistentDataGlobal.count > 9 {
                
                let n = persistentDataGlobal.count
                
                for i in n-10..<n {
                    let temp = persistentDataGlobal[i].number
                    data.append(temp)
                }
                
            }
                
            else{
                
                for i in 0..<persistentDataGlobal.count{
                    let temp = persistentDataGlobal[i].number
                    data.append(temp)
                }
            }
        }
    }
}

