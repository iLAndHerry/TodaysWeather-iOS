//
//  Enum + Weather.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/21/25.
//

import Foundation

enum Weather: String, CaseIterable {
  case happy
  case calm
  case moved
  case sad
  case verySad
  case angry
  case expressionless
  
  var normal: String { rawValue }
  
  var selected: String {
    "select" + rawValue.prefix(1).uppercased() + rawValue.dropFirst()
  }
}
