//
//  MainViewController.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/20/25.
//

import UIKit

import Then

class MainViewController: BaseViewController {
  private let calendarStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .center
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.spacing = 4
  }
  
  private let yearLabel = UILabel().then {
    $0.text = "2025"
    $0.font = .ownglyphSeoda(size: 18)
    $0.textColor = .keyColor
  }
  
  private let monthLabel = UILabel().then {
    $0.text = "8월"
    $0.font = .ownglyphSeoda(size: 36)
    $0.textColor = .g700
  }
  
  private let leftButton = UIButton().then {
    $0.setImage(.chevronLeft, for: .normal)
    $0.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
  }
  
  private let rightButton = UIButton().then {
    $0.setImage(.chevronRight, for: .normal)
    $0.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
  }
  
  private let buttonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 24
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let editButton = UIButton().then {
    $0.setImage(.edit2, for: .normal)
    $0.layer.cornerRadius = 35
    $0.backgroundColor = .keyColor
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
  }
  
  private let alignmentStack = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 2
    $0.distribution = .equalSpacing
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  // contextMenu 구현하는 것 기록하기
  private lazy var alignmentButton = UIButton().then {
    $0.setImage(.chevronDown, for: .normal)
    $0.menu = UIMenu(children: [latestAction, oldAction])
    $0.showsMenuAsPrimaryAction = true
  }
  
  private lazy var latestAction = UIAction(title: "최신순") { [weak self] _ in
    guard let self = self else { return }
    self.alignmentLabel.text = "최신순"
  }
  
  private lazy var oldAction = UIAction(title: "오래된순") { [weak self] _ in
    guard let self = self else { return }
    self.alignmentLabel.text = "오래된순"
  }
  
  private let alignmentLabel = UILabel().then {
    $0.text = "최신순"
    $0.font = .ownglyphSeoda(size: 18)
    $0.textColor = .g600
  }
  
  private let emptyView = EmptyView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func setViewController() {
    [calendarStackView, alignmentStack, editButton, emptyView].forEach {
      self.view.addSubview($0)
    }
    
    [leftButton, monthLabel, rightButton].forEach {
      buttonStackView.addArrangedSubview($0)
    }
    
    [yearLabel, buttonStackView].forEach {
      calendarStackView.addArrangedSubview($0)
    }

    [alignmentLabel, alignmentButton].forEach {
      alignmentStack.addArrangedSubview($0)
    }
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: calendarStackView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 40),
      NSLayoutConstraint(item: calendarStackView, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1.0, constant: 0.0),
      
      NSLayoutConstraint(item: editButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -26),
      NSLayoutConstraint(item: editButton, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: editButton, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 70),
      NSLayoutConstraint(item: editButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 70),
      
      NSLayoutConstraint(item: alignmentStack, attribute: .top, relatedBy: .equal, toItem: calendarStackView, attribute: .bottom, multiplier: 1.0, constant: 12),
      NSLayoutConstraint(item: alignmentStack, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      
      NSLayoutConstraint(item: emptyView, attribute: .top, relatedBy: .equal, toItem: alignmentStack, attribute: .bottom, multiplier: 1.0, constant: 10),
      NSLayoutConstraint(item: emptyView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      NSLayoutConstraint(item: emptyView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: emptyView, attribute: .bottom, relatedBy: .equal, toItem: editButton, attribute: .top, multiplier: 1.0, constant: -10)
    ])
  }
}

private extension MainViewController {
  @objc func editButtonTapped() {
    print("EditButtonTapped")
  }
  
  @objc func leftButtonTapped() {
    print("leftButtonTapped")
  }
  
  @objc func rightButtonTapped() {
    print("rightButtonTapped")
  }
}
