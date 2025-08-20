//
//  BaseViewController.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/20/25.
//

import UIKit

class BaseViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .bgColor
    setViewController()
    setAutoLayout()
    bind()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  func setViewController() {
    
  }
  
  func setAutoLayout() {
    
  }
  
  func bind() {
    
  }
}
