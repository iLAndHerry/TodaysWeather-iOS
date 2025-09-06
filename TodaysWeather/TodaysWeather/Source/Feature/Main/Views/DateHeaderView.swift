//
//  DateHeaderView.swift
//  TodaysWeather
//
//  Created by 여성일 on 9/6/25.
//

import UIKit

import Then

final class DateHeaderView: BaseView {
  var onPrevTapped: (() -> Void)?
  var onNextTapped: (() -> Void)?
  
  private let calendarStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .center
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.spacing = 4
  }
  
  private let yearLabel = UILabel().then {
    $0.font = .ownglyphSeoda(size: 18)
    $0.textColor = .keyColor
  }
  
  private let monthLabel = UILabel().then {
    $0.font = .ownglyphSeoda(size: 36)
    $0.textColor = .g700
  }
  
  private let leftButton = UIButton().then {
    $0.setImage(.chevronLeft, for: .normal)
    $0.addTarget(self, action: #selector(leftTapped), for: .touchUpInside)
  }
  
  private let rightButton = UIButton().then {
    $0.setImage(.chevronRight, for: .normal)
    $0.addTarget(self, action: #selector(rightTapped), for: .touchUpInside)
  }
  
  private let buttonStack = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 24
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func setView() {
    self.backgroundColor = .clear
    [leftButton, monthLabel, rightButton].forEach {
      buttonStack.addArrangedSubview($0)
    }
    
    [yearLabel, buttonStack].forEach {
      calendarStackView.addArrangedSubview($0)
    }
    
    self.addSubview(calendarStackView)
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: calendarStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: calendarStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: calendarStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: calendarStackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
    ])
  }
  
  func configure(year: Int, month: Int) {
    yearLabel.text = "\(year)년"
    monthLabel.text = "\(month)월"
  }
}

private extension DateHeaderView {
  @objc private func leftTapped() {
    print("left")
    onPrevTapped?()
  }
  
  @objc private func rightTapped() {
    print("right")
    onNextTapped?()
  }
}
