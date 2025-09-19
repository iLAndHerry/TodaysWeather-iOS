//
//  DetailViewController.swift
//  TodaysWeather
//
//  Created by 여성일 on 9/7/25.
//

import UIKit
import SwiftData

import Then

final class DetailViewController: BaseViewController {
  private var item: TodayWeather
  private let modelContext: ModelContext
  
  var onDeleted: (() -> Void)?
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
  
  init(item: TodayWeather, modelContext: ModelContext) {
    self.item = item
    self.modelContext = modelContext
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reloadFromStore()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    headerView.onBackButtonTapped = { [weak self] in
      guard let self = self else { return }
      self.backButtonTapped()
    }
    
    headerView.onDeleteButtonTapped = { [weak self] in
      guard let self = self else { return }
      self.deleteButtonTapped()
    }
    
    headerView.onEditButtonTapped = { [weak self] in
      guard let self = self else { return }
      self.editButtonTapped()
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
    bindUI()
  }
}

private extension DetailViewController {
  func backButtonTapped() {
    self.navigationController?.popViewController(animated: true)
  }
  
  func deleteButtonTapped() {
    let alert = UIAlertController(
      title: "정말 삭제할까요? 🥹",
      message: "삭제 후에는 되돌릴 수 없어요",
      preferredStyle: .alert
    )
    
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
      self.deleteItem()
    }
    
    let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
    
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    
    self.present(alert, animated: true)
  }
  
  func editButtonTapped() {
    let vc = WriteWeatherViewController(modelContext: modelContext, mode: .editMode(existing: item))
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - SwiftData
private extension DetailViewController {
  func reloadFromStore() {
    do {
      let targetID: UUID = item.id
      var desc = FetchDescriptor<TodayWeather>(
        predicate: #Predicate<TodayWeather> { $0.id == targetID }
      )
      desc.fetchLimit = 1
      
      if let fresh = try modelContext.fetch(desc).first {
        item = fresh
        bindUI()
      } else {
        navigationController?.popViewController(animated: true)
      }
    } catch {
      print("reload error:", error)
    }
  }
  
  func bindUI() {
    let weatherImage = UIImage(named: item.weather) ?? .happy
    let date = item.date.toKoreanString()
    let image = item.imageData.flatMap { UIImage(data: $0) }
    weatherImageView.image = weatherImage
    dateLabel.text = date
    detailContentView.configure(image: image, content: item.content, alignment: item.alignment)
  }
  
  func deleteItem() {
    modelContext.delete(item)
    do {
      try modelContext.save()
      onDeleted?()
      navigationController?.popViewController(animated: true)
    } catch {
      print("삭제 에러")
    }
  }
}
