//
//  WriteWeatherViewModel.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/21/25.
//

import Foundation

final class WriteWeatherViewModel {
  // MARK: - State
  var selectedWeather: Weather = .happy {
    didSet { onWeatherChange?(selectedWeather) }
  }
  
  var selectDate: Date? {
    didSet { onDateChange?(selectDate)}
  }
  
  var inputText: String = "" {
    didSet { onTextChange?(inputText) }
  }
  
  // MARK: - Outputs (callbacks)
  var onWeatherChange: ((Weather) -> Void)? {
    didSet { onWeatherChange?(selectedWeather) }
  }
  
  var onDateChange: ((Date?) -> Void)? {
    didSet { onDateChange?(selectDate) }
  }
  
  var onTextChange: ((String) -> Void)?
  
  init() {
    self.selectDate = Date()
    onTextChange = { text in
      print(text)
    }
  }
}
