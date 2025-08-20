//
//  WriteWeatherViewController.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/21/25.
//

import UIKit

import Then

class WriteWeatherViewController: BaseViewController {
  private let viewModel = WriteWeatherViewModel()
  
  private let headerView = BaseNavigator().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let bottomView = ToolbarView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .center
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let weatherButton = UIButton().then {
    $0.addTarget(self, action: #selector(selectWeatherButtonTapped), for: .touchUpInside)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var dateLabelButton = UIButton().then {
    var config = UIButton.Configuration.filled()
    config.image = UIImage.edit
    config.imagePlacement = .trailing
    config.imagePadding = 4
    config.baseBackgroundColor = .clear
    config.baseForegroundColor = .g500
    
    config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { container in
      var update = container
      update.font = UIFont.ownglyphSeoda(size: 18)
      update.foregroundColor = UIColor.g500
      return update
    }
    
    $0.configuration = config
    $0.addTarget(self, action: #selector(setCalendarButtonTapped), for: .touchUpInside)
  }
  
  private lazy var textView = UITextView().then {
    $0.text = "오늘 감정 날씨는 어떤 풍경이었나요?"
    $0.textColor = .g400
    $0.font = .ownglyphSeoda(size: 19.5)
    $0.layer.cornerRadius = 15
    $0.backgroundColor = .white
    $0.textContainerInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.delegate = self
  }
  
  private lazy var alert = UIAlertController(
    title: "글쓰기를 그만 두시나요? 🥲",
    message: "작성된 글이 저장되지 않아요",
    preferredStyle: .alert
  ).then {
    let exitAction = UIAlertAction(title: "나가기", style: .destructive) { _ in
      self.navigationController?.popViewController(animated: true)
    }
    
    let continueAction = UIAlertAction(title: "계속 작성", style: .default) { _ in
      print("continue")
    }
    
    $0.addAction(exitAction)
    $0.addAction(continueAction)
    
    $0.preferredAction = continueAction
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    headerView.onBackButtonTapped = { [weak self] in
      guard let self = self else { return }
      self.backButtonTapped()
    }
    
    bottomView.onSaveButtonTapped = { [weak self] in
      guard let self = self else { return }
      self.viewModel.inputText = textView.text
    }
    
    bottomView.onAlignmentButtonTapped = { [weak self] alignment in
      guard let self = self else { return }
      self.textView.textAlignment = alignment
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let vc = SelectWeatherModalViewController(viewModel: viewModel)
    present(vc, animated: true)
  }
  
  override func setViewController() {
    [headerView, stackView, textView, bottomView].forEach {
      self.view.addSubview($0)
    }
    
    [weatherButton, dateLabelButton].forEach {
      stackView.addArrangedSubview($0)
    }
  
    self.navigationController?.isNavigationBarHidden = true
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint.init(item: headerView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint.init(item: headerView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint.init(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint.init(item: headerView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 24),
      
      NSLayoutConstraint(item: weatherButton, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 82.0),
      NSLayoutConstraint(item: weatherButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 82.0),
      
      NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1.0, constant: 16.0),
      NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      
      NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 12),
      NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .top, multiplier: 1.0, constant: -28),
      
      NSLayoutConstraint(item: bottomView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: bottomView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: view.keyboardLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: bottomView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0),
    ])
  }
  
  override func bind() {
    // Output
    viewModel.onWeatherChange = { [weak self] weather in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.weatherButton.setImage(UIImage(named: weather.normal), for: .normal)
      }
    }
    
    viewModel.onDateChange = { [weak self] date in
      guard let self = self else { return }
      guard let date = date else { return }
      
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ko_KR")
      formatter.dateFormat = "M월 d일 EEEE"
      let dateString = formatter.string(from: date)
      
      var config = self.dateLabelButton.configuration
      config?.title = dateString
      self.dateLabelButton.configuration = config
    }
  }
}

// MARK: - objc Method
private extension WriteWeatherViewController {
  @objc func backButtonTapped() {
    self.present(alert, animated: true)
  }
  
  @objc func setCalendarButtonTapped() {
    let vc = SelectDateModalViewController(viewModel: viewModel)
    self.present(vc, animated: true)
  }
  
  @objc func selectWeatherButtonTapped() {
    let vc = SelectWeatherModalViewController(viewModel: viewModel)
    self.present(vc, animated: true)
  }
}

// MARK: - Delegate
extension WriteWeatherViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == .g400 {
      textView.text = nil
      textView.textColor = .g700
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "오늘 감정 날씨는 어떤 풍경이었나요?"
      textView.textColor = .g400
    }
  }
}
