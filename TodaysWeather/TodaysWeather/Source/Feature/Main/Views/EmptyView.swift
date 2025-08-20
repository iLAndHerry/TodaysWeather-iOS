//
//  EmptyView.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/20/25.
//

import UIKit

import Then

class EmptyView: BaseView {
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
    $0.alignment = .center
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let emptyImage = UIImageView().then {
    $0.image = .emptyHappy
    $0.contentMode = .scaleAspectFit
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var emptyCaptionLabel = UILabel().then {
    $0.text = "기록이 비어있어요\n시작하려면 작성하기 버튼을 탭하세요"
    $0.textColor = .g400
    $0.font = .ownglyphSeoda(size: 20)
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  
  override func setView() {
    self.addSubview(stackView)
    self.layer.cornerRadius = 10
    
    [emptyImage, emptyCaptionLabel].forEach {
      stackView.addArrangedSubview($0)
    }
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: emptyImage, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 108),
      NSLayoutConstraint(item: emptyImage, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 108),
      
      NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0.0),
    ])
  }
}
