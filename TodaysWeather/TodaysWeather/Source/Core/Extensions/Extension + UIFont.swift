//
//  Extension + UIFont.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/20/25.
//

import UIKit

extension UIFont {
  enum OwnglyphSeoda: String {
    case OwnglyphSeoda = "Ownglyph_seoda-Rg"
  }
  
  static func ownglyphSeoda(size: CGFloat) -> UIFont {
    return UIFont(name: OwnglyphSeoda.OwnglyphSeoda.rawValue, size: size)!
  }
}

extension UIFont {
  static let b1 = UIFont(name: OwnglyphSeoda.OwnglyphSeoda.rawValue, size: 18)!
}
