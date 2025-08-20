//
//  SelectDateModalViewController.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/21/25.
//

import UIKit

import Then

class SelectDateModalViewController: BaseViewController {
  private let viewModel: WriteWeatherViewModel
  
  private let prefersGabber = UIView().then {
    $0.backgroundColor = .g300
    $0.layer.cornerRadius = 3
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let selectButton = UIButton().then {
    $0.setTitle("날짜 선택하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .ownglyphSeoda(size: 22)
    $0.backgroundColor = .keyColor
    $0.layer.cornerRadius = 10
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
  }
  
  private let datePicker = UIDatePicker().then {
    $0.datePickerMode = .date
    $0.preferredDatePickerStyle = .wheels
    $0.locale = Locale(identifier: "ko-KR")
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.backgroundColor = .calendarColor
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  init(viewModel: WriteWeatherViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    datePicker.date = viewModel.selectDate ?? Date()
  }
  
  override func setViewController() {
    [prefersGabber, datePicker,  selectButton].forEach {
      self.view.addSubview($0)
    }
    
    if let sheet = self.sheetPresentationController {
      sheet.preferredCornerRadius = 15
      sheet.detents = [
        .custom(resolver: { context in
          return context.maximumDetentValue * 0.60
        })
      ]
    }
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: prefersGabber, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: prefersGabber, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 12.0),
      NSLayoutConstraint(item: prefersGabber, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0),
      NSLayoutConstraint(item: prefersGabber, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 6.0),
      
      NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal, toItem: prefersGabber, attribute: .top, multiplier: 1.0, constant: 35.0),
      NSLayoutConstraint(item: datePicker, attribute: .bottom, relatedBy: .equal, toItem: selectButton, attribute: .top, multiplier: 1.0, constant: -43.0),
      NSLayoutConstraint(item: datePicker, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16.0),
      NSLayoutConstraint(item: datePicker, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16.0),
      
      NSLayoutConstraint(item: selectButton, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      NSLayoutConstraint(item: selectButton, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: selectButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: selectButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 65)
    ])
  }
}

// MARK: - objc
private extension SelectDateModalViewController {
  @objc func selectButtonTapped() {
    viewModel.selectDate = datePicker.date
    dismiss(animated: true)
  }
}
