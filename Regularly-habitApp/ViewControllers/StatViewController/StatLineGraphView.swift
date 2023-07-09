//
//  StatLineGraphView.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 7/6/2023.
//

import UIKit
import Charts
import SwiftUI
import Foundation

struct statisticDataStructure: Identifiable {
    var id = UUID()
    var date: Date
    var count: Int
}

struct ChartUIView: View{
    
    
    var data: [statisticDataStructure] = []
    
    //Initialise chart data - Takes ActivityLog as initial parameter
    init(activityLog: ActivityLog) {
        var activityLog = activityLog
        guard let year = activityLog.year, let month = activityLog.month, let days = activityLog.day else{
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        for i in 0...days.count - 1 {
            let dateDay = String(i+1)
            let dateString = String("\(dateDay)/\(month)/\(year)")
            let statData = statisticDataStructure(date: dateFormatter.date(from: dateString) ?? Date(), count: days[i])
            data.append(statData)
        }
    }
    
    var body: some View{
        Chart(data) { userData in
            LineMark(
                x: .value("Date", userData.date ),
                y: .value("Consecutive Count", userData.count))
        }.foregroundColor(.orange)
    }
    
    
    
}


