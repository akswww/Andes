//
//  ChartFormatter.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/9/1.
//

import Foundation
import Charts

class ChartXAxisFormatter: NSObject {
      fileprivate var dateFormatter: DateFormatter?
      fileprivate var referenceTimeInterval: TimeInterval?
    
      convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
          self.init()
          self.referenceTimeInterval = referenceTimeInterval
          self.dateFormatter = dateFormatter
      }
}

extension ChartXAxisFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm"

        let date = Date(timeIntervalSince1970: value)
        return dateFormatterPrint.string(from: date)
       }
}
