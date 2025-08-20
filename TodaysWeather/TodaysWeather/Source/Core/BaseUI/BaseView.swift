//
//  BaseView.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/20/25.
//

import UIKit

import Then

class BaseView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    setView()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func setView() {
    
  }
  
  func setAutoLayout() {
    
  }
}
