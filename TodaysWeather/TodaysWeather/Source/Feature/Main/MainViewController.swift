//
//  MainViewController.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/20/25.
//

import UIKit
import SwiftData

import Then

class MainViewController: BaseViewController {
  private let modelContext: ModelContext
  
  // MARK: - Data
  private var items: [TodayWeather] = []
  private var currentYear: Int = Calendar.current.component(.year, from: Date())
  private var currentMonth: Int = Calendar.current.component(.month, from: Date())
  
  private enum SortOrder { case latest, oldest }
  private var currentSortOrder: SortOrder {
    alignmentLabel.text == "오래된순" ? .oldest : .latest
  }
  
  // MARK: - UI
  private let calendarView = DateHeaderView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let writeButton = UIButton().then {
    $0.setImage(.edit2, for: .normal)
    $0.layer.cornerRadius = 35
    $0.backgroundColor = .keyColor
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.addTarget(self, action: #selector(writeButtonTapped), for: .touchUpInside)
  }
  
  private let alignmentStack = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 2
    $0.distribution = .equalSpacing
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var alignmentButton = UIButton(type: .system).then {
    $0.setImage(.chevronDown.withRenderingMode(.alwaysOriginal), for: .normal)
    $0.menu = UIMenu(children: [latestAction, oldAction])
    $0.showsMenuAsPrimaryAction = true
  }
  
  private lazy var latestAction = UIAction(title: "최신순") { [weak self] _ in
    guard let self = self else { return }
    self.alignmentLabel.text = "최신순"
    self.fetchAndReload(sortOrder: .latest)
  }
  
  private lazy var oldAction = UIAction(title: "오래된순") { [weak self] _ in
    guard let self = self else { return }
    self.alignmentLabel.text = "오래된순"
    self.fetchAndReload(sortOrder: .oldest)
  }
  
  private let alignmentLabel = UILabel().then {
    $0.text = "최신순"
    $0.font = .ownglyphSeoda(size: 18)
    $0.textColor = .g600
  }
  
  private let emptyView = EmptyView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isHidden = true
  }
  
  private let flowLayout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .vertical
    $0.minimumLineSpacing = 12
  }
  
  private lazy var weatherListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
    $0.register(WeatherListCollectionViewCell.self,
                forCellWithReuseIdentifier: WeatherListCollectionViewCell.id)
    $0.delegate = self
    $0.dataSource = self
    $0.backgroundColor = .clear
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 10
  }
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    calendarView.configure(year: currentYear, month: currentMonth)
    
    calendarView.onPrevTapped = { [weak self] in
      guard let self else { return }
      if self.currentMonth == 1 {
        self.currentMonth = 12
        self.currentYear -= 1
      } else {
        self.currentMonth -= 1
      }
      self.calendarView.configure(year: self.currentYear, month: self.currentMonth)
      self.fetchAndReload(sortOrder: self.currentSortOrder)
    }
    calendarView.onNextTapped = { [weak self] in
      guard let self else { return }
      if self.currentMonth == 12 {
        self.currentMonth = 1
        self.currentYear += 1
      } else {
        self.currentMonth += 1
      }
      self.calendarView.configure(year: self.currentYear, month: self.currentMonth)
      self.fetchAndReload(sortOrder: self.currentSortOrder)
    }
    
    fetchAndReload(sortOrder: .latest)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.fetchAndReload(sortOrder: self.currentSortOrder)
  }
  
  override func setViewController() {
    [calendarView, alignmentStack, writeButton, weatherListCollectionView, emptyView].forEach {
      self.view.addSubview($0)
    }
    [alignmentLabel, alignmentButton].forEach { alignmentStack.addArrangedSubview($0) }
    self.navigationController?.isNavigationBarHidden = true
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: calendarView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 20.0),
      NSLayoutConstraint(item: calendarView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16.0),
      NSLayoutConstraint(item: calendarView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16.0),
      
      NSLayoutConstraint(item: alignmentStack, attribute: .top, relatedBy: .equal, toItem: calendarView, attribute: .bottom, multiplier: 1.0, constant: 12),
      NSLayoutConstraint(item: alignmentStack, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      
      NSLayoutConstraint(item: weatherListCollectionView, attribute: .top, relatedBy: .equal, toItem: alignmentStack, attribute: .bottom, multiplier: 1.0, constant: 10),
      NSLayoutConstraint(item: weatherListCollectionView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      NSLayoutConstraint(item: weatherListCollectionView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: weatherListCollectionView, attribute: .bottom, relatedBy: .equal, toItem: writeButton, attribute: .top, multiplier: 1.0, constant: -10),
      
      
      NSLayoutConstraint(item: emptyView, attribute: .top, relatedBy: .equal, toItem: alignmentStack, attribute: .bottom, multiplier: 1.0, constant: 10),
      NSLayoutConstraint(item: emptyView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide,attribute: .leading, multiplier: 1.0, constant: 16),
      NSLayoutConstraint(item: emptyView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: emptyView, attribute: .bottom, relatedBy: .equal, toItem: writeButton, attribute: .top, multiplier: 1.0, constant: -10),
      
      NSLayoutConstraint(item: writeButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -26),
      NSLayoutConstraint(item: writeButton, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: writeButton, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 70),
      NSLayoutConstraint(item: writeButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 70),
    ])
  }
}

// MARK: - SwiftData
extension MainViewController {
  private func monthRange(year: Int, month: Int) -> (start: Date, end: Date)? {
    var comps = DateComponents(year: year, month: month, day: 1)
    let cal = Calendar.current
    guard let start = cal.date(from: comps) else { return nil }
    guard let end = cal.date(byAdding: DateComponents(month: 1), to: start) else { return nil }
    return (start, end)
  }
  
  private func fetchAndReload(sortOrder: SortOrder) {
    guard let range = monthRange(year: currentYear, month: currentMonth) else { return }
    let start = range.start
    let end = range.end
    
    do {
      let sort: SortDescriptor<TodayWeather> = {
        switch sortOrder {
        case .latest: return SortDescriptor(\.createdAt, order: .reverse)
        case .oldest: return SortDescriptor(\.createdAt, order: .forward)
        }
      }()
      
      let predicate = #Predicate<TodayWeather> { item in
        item.date >= start && item.date < end
      }
      
      let descriptor = FetchDescriptor<TodayWeather>(predicate: predicate, sortBy: [sort])
      items = try modelContext.fetch(descriptor)
      
      let isEmpty = items.isEmpty
      emptyView.isHidden = !isEmpty
      weatherListCollectionView.isHidden = isEmpty
      
      weatherListCollectionView.reloadData()
    } catch {
      print("❌ fetch error:", error)
    }
  }
}

// MARK: - Actions
private extension MainViewController {
  @objc func writeButtonTapped() {
    let vc = WriteWeatherViewController(modelContext: modelContext, mode: .writeMode)
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - Layout
private extension MainViewController {
  var cellPaddingTop: CGFloat { 24 }
  var cellPaddingBottom: CGFloat { 24 }
  var leftInset: CGFloat { 16 }
  var rightInset: CGFloat { 16 }
  var leftStackWidth: CGFloat { 85 }
  var gapBetweenLeftAndRight: CGFloat { 24 }
  var gapBetweenContentAndImage: CGFloat { 10 }
  
  func rightContentWidth(for collectionViewWidth: CGFloat) -> CGFloat {
    collectionViewWidth - (leftInset + leftStackWidth + gapBetweenLeftAndRight + rightInset)
  }
  
  func heightForText(_ text: String, width: CGFloat, font: UIFont, maxLines: Int = 0) -> CGFloat {
    let label = UILabel()
    label.numberOfLines = maxLines == 0 ? 0 : maxLines
    label.font = font
    label.text = text
    let size = label.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    if maxLines > 0 { return min(size.height, CGFloat(maxLines) * font.lineHeight) }
    return size.height
  }
  
  func heightForImage(_ image: UIImage?, targetWidth: CGFloat) -> CGFloat {
    guard let image, image.size.width > 0 else { return 0 }
    let ratio = image.size.height / image.size.width
    let h = targetWidth * ratio
    return min(max(h, 100), 350)
  }
  
  func leftStackHeight(for dateText: String, dateFont: UIFont) -> CGFloat {
    let weatherIconHeight: CGFloat = 85
    let stackSpacing: CGFloat = 4
    let dateH = heightForText(dateText, width: leftStackWidth, font: dateFont, maxLines: 2)
    return weatherIconHeight + stackSpacing + dateH
  }
  
  func heightForItem(_ item: TodayWeather, collectionViewWidth: CGFloat) -> CGFloat {
    let contentWidth = rightContentWidth(for: collectionViewWidth)
    let dateText = item.date.toKoreanMultiLineString()
    let dateFont = UIFont.ownglyphSeoda(size: 14)
    let contentFont = UIFont.ownglyphSeoda(size: 18)
    
    let textH = heightForText(item.content, width: contentWidth, font: contentFont)
    let imageH = heightForImage(item.imageData.flatMap { UIImage(data: $0) }, targetWidth: contentWidth)
    let rightBlockH = textH + (imageH > 0 ? (gapBetweenContentAndImage + imageH) : 0)
    let leftBlockH = leftStackHeight(for: dateText, dateFont: dateFont)
    
    return cellPaddingTop + max(rightBlockH, leftBlockH) + cellPaddingBottom
  }
}

// MARK: - Delegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width
    let item = items[indexPath.item]
    let height = heightForItem(item, collectionViewWidth: width)
    return CGSize(width: width, height: height)
  }
}

extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    items.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: WeatherListCollectionViewCell.id,
      for: indexPath
    ) as? WeatherListCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let item = items[indexPath.item]
    let weatherImage = UIImage(named: item.weather) ?? .happy
    let image = item.imageData.flatMap { UIImage(data: $0) }
    let dateString = item.date.toKoreanMultiLineString()
    cell.configure(weather: weatherImage, date: dateString, content: item.content, imageData: image)
    return cell
  }
}

extension MainViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = items[indexPath.item]
    let vc = DetailViewController(item: item, modelContext: modelContext)
    vc.onDeleted = { [weak self] in
      guard let self = self else { return }
      self.fetchAndReload(sortOrder: self.currentSortOrder)
    }
    navigationController?.pushViewController(vc, animated: true)
  }
}
