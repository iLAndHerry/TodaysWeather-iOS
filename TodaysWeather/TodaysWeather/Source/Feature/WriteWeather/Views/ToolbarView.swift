//
//  ToolbarView.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/21/25.
//

import UIKit

import Then

final class ToolbarView: BaseView {
  var onSaveButtonTapped: (() -> Void)?
  var onImageButtonTapped: (() -> Void)?
  var onAlignmentButtonTapped: ((EditorAlignment) -> Void)?
  
  private var isCenterAligned = false
  
  private let strokeView = UIView().then {
    $0.backgroundColor = .g300
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.spacing = 12
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var imageButton = UIButton().then {
    $0.setImage(.imageButton, for: .normal)
    $0.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var alignmentButton = UIButton().then {
    $0.setImage(.alignLeft, for: .normal)
    $0.addTarget(self, action: #selector(alignmentButtonTapped), for: .touchUpInside)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var saveButton = UIButton().then {
    $0.setImage(.checkButton, for: .normal)
    $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func setView() {
    self.backgroundColor = .g100
    [strokeView, stackView, saveButton].forEach { self.addSubview($0) }
    [imageButton, alignmentButton].forEach { stackView.addArrangedSubview($0) }
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: strokeView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: strokeView, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: strokeView, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: strokeView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0),
      
      NSLayoutConstraint.init(item: imageButton, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 24),
      NSLayoutConstraint.init(item: imageButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 24),
      
      NSLayoutConstraint.init(item: alignmentButton, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 24),
      NSLayoutConstraint.init(item: alignmentButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 24),
      
      NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 12),
      NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      
      NSLayoutConstraint(item: saveButton, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 12),
      NSLayoutConstraint(item: saveButton, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      NSLayoutConstraint.init(item: saveButton, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 24),
      NSLayoutConstraint.init(item: saveButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 24),
    ])
  }
}

// MARK: - objc Method
private extension ToolbarView {
  @objc func saveButtonTapped() {
    onSaveButtonTapped?()
  }
  
  @objc func alignmentButtonTapped() {
    isCenterAligned.toggle()
    
    if isCenterAligned {
      alignmentButton.setImage(.alignCenter, for: .normal)
      onAlignmentButtonTapped?(.center)
    } else {
      alignmentButton.setImage(.alignLeft, for: .normal)
      onAlignmentButtonTapped?(.left)
    }
  }
  
  @objc func imageButtonTapped() {
    onImageButtonTapped?()
  }
}

extension ToolbarView {
  func setAlignmentButton(_ alignment: EditorAlignment) {
    isCenterAligned = (alignment == .center)
    let image: UIImage = isCenterAligned ? .alignCenter : .alignLeft
    alignmentButton.setImage(image, for: .normal)
  }
}
