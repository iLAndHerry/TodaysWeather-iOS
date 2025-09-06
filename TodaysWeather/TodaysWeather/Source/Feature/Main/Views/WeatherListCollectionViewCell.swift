//
//  WeatherListCollectionViewCell.swift
//  TodaysWeather
//
//  Created by 여성일 on 9/6/25.
//

import UIKit
import Then

final class WeatherListCollectionViewCell: UICollectionViewCell {
  static let id = "WeatherListCollectionViewCell"
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .center
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let weatherImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let dateLabel = UILabel().then {
    $0.font = .ownglyphSeoda(size: 14)
    $0.textAlignment = .center
    $0.textColor = .keyColor
    $0.numberOfLines = 2
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let contentTextLabel = UILabel().then {
    $0.textAlignment = .left
    $0.textColor = .g600
    $0.font = .ownglyphSeoda(size: 18)
    $0.numberOfLines = 0
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let previewImageView = UIImageView().then {
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.contentMode = .scaleAspectFill
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private var previewImageHeight: NSLayoutConstraint!
  
  private var currentImage: UIImage?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
    backgroundColor = .white
    layer.cornerRadius = 10
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
    setupConstraints()
    backgroundColor = .white
    layer.cornerRadius = 10
  }
  
  func configure(weather: UIImage, date: String, content: String, imageData: UIImage?) {
    weatherImageView.image = weather
    dateLabel.text = date
    contentTextLabel.text = content
    
    currentImage = imageData
    if let img = imageData {
      previewImageView.isHidden = false
      previewImageView.image = img
    } else {
      previewImageView.isHidden = true
      previewImageView.image = nil
      previewImageHeight.constant = 0
    }
    
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    weatherImageView.image = nil
    dateLabel.text = nil
    contentTextLabel.text = nil
    previewImageView.image = nil
    previewImageView.isHidden = true
    previewImageHeight.constant = 0
    currentImage = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    guard let img = currentImage else { return }
    
    let availableWidth = contentView.bounds.width - (16 + 85 + 24 + 16)
    guard availableWidth > 0 else { return }
    
    let ratio = img.size.height / img.size.width
    let rawH = availableWidth * ratio
    let clamped = max(100, min(350, rawH))
    
    if abs(previewImageHeight.constant - clamped) > 0.5 {
      previewImageHeight.constant = clamped
      contentView.layoutIfNeeded()
    }
  }
}

// MARK: - Layout
private extension WeatherListCollectionViewCell {
  func setupViews() {
    [weatherImageView, dateLabel].forEach { stackView.addArrangedSubview($0) }
    [stackView, contentTextLabel, previewImageView].forEach { contentView.addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.widthAnchor.constraint(equalToConstant: 85),
      stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
    ])
    
    weatherImageView.widthAnchor.constraint(equalToConstant: 85).isActive = true
    weatherImageView.heightAnchor.constraint(equalToConstant: 85).isActive = true
  
    NSLayoutConstraint.activate([
      contentTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
      contentTextLabel.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 24),
      contentTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
    
    previewImageHeight = previewImageView.heightAnchor.constraint(equalToConstant: 0)
    previewImageHeight.isActive = true
    
    NSLayoutConstraint.activate([
      previewImageView.topAnchor.constraint(equalTo: contentTextLabel.bottomAnchor, constant: 10),
      previewImageView.leadingAnchor.constraint(equalTo: contentTextLabel.leadingAnchor),
      previewImageView.trailingAnchor.constraint(equalTo: contentTextLabel.trailingAnchor),
      previewImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
    ])
  }
}
