//
//  Extension + Date.swift
//  TodaysWeather
//
//  Created by 여성일 on 9/6/25.
//

import Foundation

extension Date {
  func toKoreanString() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "M월 d일 EEEE"
    return formatter.string(from: self)
  }
  
  func toKoreanMultiLineString() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "M월 d일 EEEE"
    let fullString = formatter.string(from: self)
    
    if let range = fullString.range(of: " ", options: .backwards) {
      let datePart = String(fullString[..<range.lowerBound])
      let weekdayPart = String(fullString[range.upperBound...])
      return "\(datePart)\n\(weekdayPart)"
    }
    
    return fullString
  }
}

