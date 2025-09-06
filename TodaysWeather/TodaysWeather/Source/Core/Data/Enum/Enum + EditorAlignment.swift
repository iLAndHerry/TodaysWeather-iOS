//
//  Enum + EditorAlignment.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/25/25.
//

import UIKit

enum EditorAlignment {
  case left, center
  
  var nsTextAlignment: NSTextAlignment {
    switch self {
    case .left: return .left
    case .center: return .center
    }
  }
}
