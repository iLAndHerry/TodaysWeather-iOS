//
//  SelectWeatherModalViewController.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/21/25.
//

import UIKit

import Then

class SelectWeatherModalViewController: BaseViewController {
  private let viewModel: WriteWeatherViewModel
  
  private let prefersGabber = UIView().then {
    $0.backgroundColor = .g300
    $0.layer.cornerRadius = 3
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "오늘의 감정을 선택해주세요!"
    $0.font = .ownglyphSeoda(size: 24)
    $0.textColor = .g700
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let flowLayout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .vertical
  }
  
  private lazy var selectWeatherCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
    $0.backgroundColor = .clear
    $0.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.id)
    $0.delegate = self
    $0.dataSource = self
    $0.isScrollEnabled = false
    $0.allowsMultipleSelection = false
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let selectButton = UIButton().then {
    $0.setTitle("선택하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .ownglyphSeoda(size: 22)
    $0.backgroundColor = .keyColor
    $0.layer.cornerRadius = 10
    $0.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
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
    
    let target = viewModel.selectedWeather
    if let ip = indexPath(for: target) {
      selectWeatherCollectionView.selectItem(at: ip, animated: false, scrollPosition: [])
    } else if let happyIP = indexPath(for: .happy) {
      selectWeatherCollectionView.selectItem(at: happyIP, animated: false, scrollPosition: [])
      viewModel.selectedWeather = .happy
    }
  }
  
  override func setViewController() {
    [prefersGabber, titleLabel, selectWeatherCollectionView, selectButton].forEach {
      self.view.addSubview($0)
    }
    self.view.backgroundColor = .white
    if let sheet = self.sheetPresentationController {
      sheet.preferredCornerRadius = 15
      sheet.detents = [
        .custom(resolver: { context in
          return context.maximumDetentValue * 0.95
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
      
      NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: prefersGabber, attribute: .bottom, multiplier: 1.0, constant: 42.0),
      
      NSLayoutConstraint(item: selectWeatherCollectionView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 56.0),
      NSLayoutConstraint(item: selectWeatherCollectionView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16.0),
      NSLayoutConstraint(item: selectWeatherCollectionView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16.0),
      NSLayoutConstraint(item: selectWeatherCollectionView, attribute: .bottom, relatedBy: .equal, toItem: selectButton, attribute: .top, multiplier: 1.0, constant: -98.0),
      
      NSLayoutConstraint(item: selectButton, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      NSLayoutConstraint(item: selectButton, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: selectButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: selectButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 65)
    ])
  }
}

// MARK: - Delegate
extension SelectWeatherModalViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let weather = sectionImages[indexPath.section][indexPath.item]
    viewModel.selectedWeather = weather
  }
}

extension SelectWeatherModalViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 108, height: 120)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8.5
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let interItemSpacing: CGFloat = 8.5
    let inset: CGFloat = 0
    
    let columns: CGFloat = (section == 0) ? 3 : 2
    let availableWidth = collectionView.bounds.width - inset * 2
    let totalCellWidth = columns * 108
    let totalSpacingWidth = interItemSpacing * (columns - 1)
    let leftover = availableWidth - totalCellWidth - totalSpacingWidth
    
    let sideInset = max(leftover / 2, 0)
    return UIEdgeInsets(top: 0, left: sideInset, bottom: 12, right: sideInset)
  }
}

extension SelectWeatherModalViewController: UICollectionViewDataSource {
  private var sectionImages: [[Weather]] {
    return [
      [.happy, .calm, .moved],
      [.sad, .verySad],
      [.angry, .expressionless]
    ]
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sectionImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sectionImages[section].count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.id, for: indexPath) as? WeatherCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let name = sectionImages[indexPath.section][indexPath.item]
    if let image = UIImage(named: name.selected) {
      cell.configure(image: image)
    }
    
    return cell
  }
}

// MARK: - objc
private extension SelectWeatherModalViewController {
  @objc func selectButtonTapped() {
    dismiss(animated: true)
  }
}

// MARK: - Method
extension SelectWeatherModalViewController {
  private func indexPath(for weather: Weather) -> IndexPath? {
    for (section, row) in sectionImages.enumerated() {
      if let item = row.firstIndex(of: weather) {
        return IndexPath(item: item, section: section)
      }
    }
    return nil
  }
}
