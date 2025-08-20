//
//  BaseNavigator.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/20/25.
//

import UIKit

import Then

class BaseNavigator: BaseView {
  var onBackButtonTapped: (() -> Void)?
  var onEditButtonTapped: (() -> Void)?
  var onShareButtonTapped: (() -> Void)?
  var onImageSaveButtonTapped: (() -> Void)?
  var onDeleteButtonTapped: (() -> Void)?
  
  private lazy var backButton = UIButton().then {
    $0.setImage(.chevronLeft.withTintColor(.keyColor, renderingMode: .alwaysOriginal), for: .normal)
    $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var toastButton = UIButton().then {
    $0.setImage(.toastButton, for: .normal)
    $0.menu = UIMenu(children: [editButtonAction, shareButtonAction, imageSaveButtonAction, deleteButtonAction])
    $0.showsMenuAsPrimaryAction = true
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var editButtonAction = UIAction(title: "수정하기", image: UIImage(systemName: "pencil")) { [weak self] _ in
    guard let self = self else { return }
    self.onEditButtonTapped?()
  }
  
  private lazy var shareButtonAction = UIAction(title: "공유하기", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
    guard let self = self else { return }
    self.onShareButtonTapped?()
  }
  
  private lazy var imageSaveButtonAction = UIAction(title: "이미지 저장", image: UIImage(systemName: "square.and.arrow.down")) { [weak self] _ in
    guard let self = self else { return }
    self.onImageSaveButtonTapped?()
  }
  
  private lazy var deleteButtonAction = UIAction(title: "삭제하기", image: UIImage(systemName: "trash")) { [weak self] _ in
    guard let self = self else { return }
    self.onDeleteButtonTapped?()
  }
  
  override func setView() {
    [backButton, toastButton].forEach {
      self.addSubview($0)
    }
    self.backgroundColor = .clear
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint.init(item: backButton, attribute: .centerY, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint.init(item: backButton, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16.0),
      
      NSLayoutConstraint.init(item: toastButton, attribute: .centerY, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint.init(item: toastButton, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16.0),
    ])
  }
}

private extension BaseNavigator {
  @objc private func backButtonTapped() {
    onBackButtonTapped?()
  }
}
