//
//  SplashViewController.swift
//  TodaysWeather
//
//  Created by 여성일 on 9/20/25.
//

import UIKit

import Then

final class SplashViewController: BaseViewController {
  var onFinished: (() -> Void)?
  
  private let logoImage = UIImageView().then {
    $0.image = .happy
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let logoText = UILabel().then {
    $0.text = "오늘의 날씨"
    $0.textColor = .keyColor
    $0.font = .ownglyphSeoda(size: 25)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 6
    $0.alignment = .center
    $0.distribution = .equalSpacing
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.onFinished?()
    }
  }
  override func setViewController() {
    self.navigationController?.isNavigationBarHidden = true
    
    view.addSubview(stackView)
    
    [logoImage, logoText].forEach {
      stackView.addArrangedSubview($0)
    }
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: logoImage, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 105.0),
      NSLayoutConstraint(item: logoImage, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 105.0),
    ])
    
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1.0, constant: 0.0),
    ])
  }
}
