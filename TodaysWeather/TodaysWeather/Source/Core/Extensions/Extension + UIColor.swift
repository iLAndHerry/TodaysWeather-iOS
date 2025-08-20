//
//  Extension + UIColor.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/20/25.
//

import UIKit

extension UIColor {
  convenience init(hexCode: UInt, alpha: CGFloat = 1.0) {
    self.init(
      red: CGFloat((hexCode & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hexCode & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(hexCode & 0x0000FF) / 255.0,
      alpha: CGFloat(alpha)
    )
  }
}

extension UIColor {
  static let keyColor = UIColor(hexCode: 0x8C7567)
  static let bgColor = UIColor(hexCode: 0xF2F2F7)
  static let calendarColor = UIColor(hexCode: 0xF7F7F7)
  
  // Button
  static let btnDefault = UIColor(hexCode: 0x8C7567)
  static let btnHover = UIColor(hexCode: 0x5B4F48)
  
  // GrayScale
  static let g100 = UIColor(hexCode: 0xF3F3F3)
  static let g200 = UIColor(hexCode: 0xECECEC)
  static let g300 = UIColor(hexCode: 0xD9D9D9)
  static let g400 = UIColor(hexCode: 0xAEAEAE)
  static let g500 = UIColor(hexCode: 0x888888)
  static let g600 = UIColor(hexCode: 0x565656)
  static let g700 = UIColor(hexCode: 0x404048)
}
