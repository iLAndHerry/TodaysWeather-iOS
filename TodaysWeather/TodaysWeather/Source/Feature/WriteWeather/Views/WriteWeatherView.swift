//
//  WriteWeatherView.swift
//  TodaysWeather
//
//  Created by 여성일 on 9/6/25.
//

import UIKit

import Then

final class WriteWeatherView: BaseView {
  var onDeleteImageButtonTapped: (() -> Void)?
  
  private var imageHeightConstraint: NSLayoutConstraint!
  private var textTopToImageConstraint: NSLayoutConstraint!
  private var textTopToContentTopConstraint: NSLayoutConstraint!
  
  private let scrollView = UIScrollView().then {
    $0.layer.cornerRadius = 15
    $0.delaysContentTouches = false
    $0.canCancelContentTouches = true
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let imageView = WeatherImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var textView = UITextView().then {
    $0.text = "오늘 감정 날씨는 어떤 풍경이었나요?"
    $0.textColor = .g400
    $0.font = .ownglyphSeoda(size: 19.5)
    $0.backgroundColor = .white
    $0.isScrollEnabled = false
    $0.textContainerInset = UIEdgeInsets(top: 12, left: 24, bottom: 24, right: 24)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func setView() {
    self.addSubview(scrollView)
    self.layer.cornerRadius = 15
    
    [imageView, textView].forEach {
      self.scrollView.addSubview($0)
    }
    
    imageView.onDeleteImageButtonTapped = { [weak self] in
      self?.onDeleteImageButtonTapped?()
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
      NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: scrollView.frameLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: scrollView.frameLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: scrollView.contentLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0.0),
    ])
    textTopToImageConstraint = NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 12.0)
    textTopToContentTopConstraint = NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: scrollView.contentLayoutGuide, attribute: .top, multiplier: 1.0, constant: 12.0)
    
    textTopToContentTopConstraint.isActive = true
    textTopToImageConstraint.isActive = false
    
    imageView.isHidden = true
  }
}

extension WriteWeatherView {
  func configure(image: UIImage?) {
    if let image {
      imageView.isHidden = false
      imageView.configure(image: image)
      
      let availableWidth = scrollView.frameLayoutGuide.layoutFrame.width - 24
      let ratio = image.size.height / image.size.width
      let targetHeight = availableWidth * ratio
      
      imageHeightConstraint.constant = min(targetHeight, 350)
      
      textTopToContentTopConstraint.isActive = false
      textTopToImageConstraint.isActive = true
    } else {
      imageView.configure(image: nil)
      imageView.isHidden = true
      imageHeightConstraint.constant = 0.0
      
      textTopToImageConstraint.isActive = false
      textTopToContentTopConstraint.isActive = true
    }
    
    setNeedsLayout()
    layoutIfNeeded()
    
    DispatchQueue.main.async { [weak self] in
      self?.adjustScrollPosition()
    }
  }
  
  func setTextAlignment(_ alignment: EditorAlignment) {
    textView.textAlignment = alignment.nsTextAlignment
  }
  
  func setTextViewDelegate(_ delegate: UITextViewDelegate) {
    textView.delegate = delegate
  }
  
  private func adjustScrollPosition() {
    let contentHeight = scrollView.contentSize.height
    let scrollViewHeight = scrollView.bounds.height
    
    if contentHeight > scrollViewHeight {
      let maxOffsetY = contentHeight - scrollViewHeight
      let targetOffsetY = min(maxOffsetY, contentHeight * 0.7)
      
      scrollView.setContentOffset(CGPoint(x: 0, y: targetOffsetY), animated: true)
    }
  }
  
  func scrollToCursor() {
    guard let selectedRange = textView.selectedTextRange else { return }
    
    let caretRect = textView.caretRect(for: selectedRange.start)
    let convertedRect = textView.convert(caretRect, to: scrollView)
    
    let scrollViewHeight = scrollView.bounds.height
    let targetOffsetY = max(0, convertedRect.maxY - scrollViewHeight + 24)
    
    if targetOffsetY > scrollView.contentOffset.y || convertedRect.minY < scrollView.contentOffset.y {
      scrollView.setContentOffset(CGPoint(x: 0, y: targetOffsetY), animated: true)
    }
  }
  
  func handleTextViewContentSizeChange() {
    DispatchQueue.main.async { [weak self] in
      self?.scrollToCursor()
    }
  }
}

extension WriteWeatherView {
  func textViewDidChange(_ textView: UITextView) {
    handleTextViewContentSizeChange()
  }
  
  func textViewDidChangeSelection(_ textView: UITextView) {
    DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
      self?.scrollToCursor()
    }
  }
}
