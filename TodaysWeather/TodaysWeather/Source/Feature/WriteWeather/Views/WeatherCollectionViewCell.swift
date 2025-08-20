//
//  WeatherCollectionViewCell.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/21/25.
//

import UIKit

import Then

class WeatherCollectionViewCell: UICollectionViewCell {
  static let id: String = "WeatherCollectionViewCell"
  
  private let weatherImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setCell()
    setAutoLayout()
    
    self.layer.cornerRadius = 10
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func configure(image: UIImage) {
    weatherImageView.image = image
  }
  
  override var isSelected: Bool {
    didSet {
      self.backgroundColor = isSelected ? .g100 : .clear
    }
  }
}

// MARK: - Private Method
private extension WeatherCollectionViewCell {
  func setCell() {
    self.contentView.addSubview(weatherImageView)
  }
  
  func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: weatherImageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: weatherImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: weatherImageView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: weatherImageView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
    ])
  }
}
