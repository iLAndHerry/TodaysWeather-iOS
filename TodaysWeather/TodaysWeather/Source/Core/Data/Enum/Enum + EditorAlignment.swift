//
//  Enum + EditorAlignment.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/25/25.
//

// Enum + EditorAlignment.swift
import UIKit

enum EditorAlignment: Int, Codable, CaseIterable, Sendable {
  case left = 0
  case center = 1

  var nsTextAlignment: NSTextAlignment {
    switch self {
    case .left: return .left
    case .center: return .center
    }
  }
}
