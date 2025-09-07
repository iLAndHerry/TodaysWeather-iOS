//
//  DetailViewController.swift
//  TodaysWeather
//
//  Created by 여성일 on 9/7/25.
//

import UIKit

import Then

final class DetailViewController: BaseViewController {
  private let item: TodayWeather
  
  private let headerView = BaseNavigator().then {
    $0.showsToastButton = true
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .center
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let weatherImageView = UIImageView().then {
    $0.image = .moved
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let dateLabel = UILabel().then {
    $0.text = "9월 7일 일요일"
    $0.font = .ownglyphSeoda(size: 18)
    $0.textColor = .g500
    $0.textAlignment = .center
    $0.numberOfLines = 1
  }
  
  private let detailContentView = DetailContentView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  init(item: TodayWeather) {
    self.item = item
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    headerView.onBackButtonTapped = { [weak self] in
      guard let self = self else { return }
      self.backButtonTapped()
    }
  }
  
  override func setViewController() {
    [weatherImageView, dateLabel].forEach {
      self.stackView.addArrangedSubview($0)
    }
    
    [headerView, stackView, detailContentView].forEach {
      self.view.addSubview($0)
    }
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint.init(item: headerView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint.init(item: headerView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint.init(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint.init(item: headerView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 24)
    ])
    
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: weatherImageView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 82.0),
      NSLayoutConstraint(item: weatherImageView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 82.0),
    ])
    
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1.0, constant: 16.0),
      NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
    ])
    
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: detailContentView, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 12),
      NSLayoutConstraint(item: detailContentView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      NSLayoutConstraint(item: detailContentView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: detailContentView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -16),
    ])
  }
  
  override func bind() {
    let weatherImage = UIImage(named: item.weather) ?? .happy
    let date = item.date.toKoreanString()
    let image = item.imageData.flatMap { UIImage(data: $0) }
    weatherImageView.image = weatherImage
    dateLabel.text = date
    detailContentView.configure(image: image, content: item.content, alignment: item.alignment)
  }
}

private extension DetailViewController {
  func backButtonTapped() {
    self.navigationController?.popViewController(animated: true)
  }
}
