//
//  DetailContentView.swift
//  TodaysWeather
//
//  Created by 여성일 on 9/7/25.
//

import UIKit

import Then

final class DetailContentView: BaseView {
  private var imageHeightConstraint: NSLayoutConstraint!
  private var textTopToImageConstraint: NSLayoutConstraint!
  private var textTopToContentTopConstraint: NSLayoutConstraint!
  
  private let scrollView = UIScrollView().then {
    $0.layer.cornerRadius = 15
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let imageView = UIImageView().then {
    $0.image = .test
    $0.layer.cornerRadius = 15
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let contentLabel = UILabel().then {
    $0.font = .ownglyphSeoda(size: 19.5)
    $0.textColor = .g700
    $0.numberOfLines = 0
    $0.backgroundColor = .clear
    $0.lineBreakMode = .byWordWrapping
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    //configure(image: .test)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func setView() {
    self.addSubview(scrollView)
    self.layer.cornerRadius = 15
    self.backgroundColor = .white
    
    [imageView, contentLabel].forEach {
      self.scrollView.addSubview($0)
    }
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0.0),
    ])
    
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: scrollView.contentLayoutGuide, attribute: .top, multiplier: 1.0, constant: 24.0),
      NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: scrollView.frameLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 24.0),
      NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: scrollView.frameLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -24.0),
    ])
    imageHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
    imageHeightConstraint.isActive = true
    
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: contentLabel, attribute: .leading, relatedBy: .equal, toItem: scrollView.frameLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 24.0),
      NSLayoutConstraint(item: contentLabel, attribute: .trailing, relatedBy: .equal, toItem: scrollView.frameLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -24.0),
      NSLayoutConstraint(item: contentLabel, attribute: .bottom, relatedBy: .equal, toItem: scrollView.contentLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -24.0),
    ])
    textTopToImageConstraint = NSLayoutConstraint(item: contentLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 32.0)
    textTopToContentTopConstraint = NSLayoutConstraint(item: contentLabel, attribute: .top, relatedBy: .equal, toItem: scrollView.contentLayoutGuide, attribute: .top, multiplier: 1.0, constant: 24.0)
    
    textTopToContentTopConstraint.isActive = true
    textTopToImageConstraint.isActive = false
    
    imageView.isHidden = true
  }
}

extension DetailContentView {
  func configure(image: UIImage?, content: String, alignment: EditorAlignment) {
    if let image {
      imageView.isHidden = false
      imageView.image = image
      
      let availableWidth = scrollView.frameLayoutGuide.layoutFrame.width - 24
      let ratio = image.size.height / image.size.width
      let targetHeight = availableWidth * ratio
      
      imageHeightConstraint.constant = min(targetHeight, 350)
      
      textTopToContentTopConstraint.isActive = false
      textTopToImageConstraint.isActive = true
    } else {
      imageView.image = nil
      imageView.isHidden = true
      imageHeightConstraint.constant = 0.0
      
      textTopToImageConstraint.isActive = false
      textTopToContentTopConstraint.isActive = true
    }
    
    contentLabel.text = content
    contentLabel.textAlignment = alignment.nsTextAlignment
    setNeedsLayout()
    layoutIfNeeded()
  }
}
