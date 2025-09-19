//
//  WriteWeatherViewController.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/21/25.
//

import UIKit
import SwiftData
import PhotosUI

import Then

final class WriteWeatherViewController: BaseViewController {
  private let mode: ViewMode
  
  private var lastPickedAssetId: String?
  private var shouldPreselect: Bool = true
  private var didPresentOnApper = false
  
  private let modelContext: ModelContext
  private let viewModel: WriteWeatherViewModel
  
  private let headerView = BaseNavigator().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let toolbar = ToolbarView().then {
    $0.isUserInteractionEnabled = true
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .center
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let weatherButton = UIButton().then {
    $0.addTarget(self, action: #selector(selectWeatherButtonTapped), for: .touchUpInside)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var dateLabelButton = UIButton().then {
    var config = UIButton.Configuration.filled()
    config.image = UIImage.edit
    config.imagePlacement = .trailing
    config.imagePadding = 4
    config.baseBackgroundColor = .clear
    config.baseForegroundColor = .g500
    
    config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { container in
      var update = container
      update.font = UIFont.ownglyphSeoda(size: 18)
      update.foregroundColor = UIColor.g500
      return update
    }
    
    $0.configuration = config
    $0.addTarget(self, action: #selector(setCalendarButtonTapped), for: .touchUpInside)
  }
  
  private lazy var writeView = WriteWeatherView().then {
    $0.layer.cornerRadius = 15
    $0.setTextViewDelegate(self)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  init(modelContext: ModelContext, mode: ViewMode) {
    self.modelContext = modelContext
    self.mode = mode
    self.viewModel = WriteWeatherViewModel(modelContext: modelContext)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    headerView.onBackButtonTapped = { [weak self] in
      guard let self = self else { return }
      self.showWriteCancelAlert()
    }
    
    toolbar.onSaveButtonTapped = { [weak self] in
      guard let self = self else { return }
      self.writeView.endEditingIfNeeded()
      
      switch self.mode {
      case .writeMode:
        self.viewModel.save()
      case .editMode(let existing):
        self.viewModel.update(existing: existing)
      }
    }
    
    toolbar.onAlignmentButtonTapped = { [weak self] alignment in
      guard let self = self else { return }
      self.writeView.setTextAlignment(alignment)
      self.viewModel.alignment = alignment
    }
    
    toolbar.onImageButtonTapped = { [weak self] in
      guard let self = self else { return }
      let picker = self.makeImagePicker()
      self.present(picker, animated: true)
    }
    
    writeView.onDeleteImageButtonTapped = { [weak self] in
      guard let self = self else { return }
      self.viewModel.imageData = nil
      self.writeView.configure(image: nil)
      self.lastPickedAssetId = nil
      self.shouldPreselect = false
    }
    
    applyModeInitialSetup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard !didPresentOnApper else { return }
    didPresentOnApper = true
    
    if case .writeMode = mode {
      let vc = SelectWeatherModalViewController(viewModel: viewModel)
      present(vc, animated: true)
    }
  }
  
  override func setViewController() {
    [headerView, stackView, writeView, toolbar].forEach {
      self.view.addSubview($0)
    }
    
    [weatherButton, dateLabelButton].forEach {
      stackView.addArrangedSubview($0)
    }
    
    self.navigationController?.isNavigationBarHidden = true
  }
  
  override func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint.init(item: headerView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint.init(item: headerView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint.init(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint.init(item: headerView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 24),
      
      NSLayoutConstraint(item: weatherButton, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 82.0),
      NSLayoutConstraint(item: weatherButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 82.0),
      
      NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1.0, constant: 16.0),
      NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      
      NSLayoutConstraint(item: writeView, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 12),
      NSLayoutConstraint(item: writeView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 16),
      NSLayoutConstraint(item: writeView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: -16),
      NSLayoutConstraint(item: writeView, attribute: .bottom, relatedBy: .equal, toItem: toolbar, attribute: .top, multiplier: 1.0, constant: -16),
      
      NSLayoutConstraint(item: toolbar, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: toolbar, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: toolbar, attribute: .bottom, relatedBy: .equal, toItem: view.keyboardLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: toolbar, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0),
    ])
  }
  
  override func bind() {
    // Output
    viewModel.onWeatherChange = { [weak self] weather in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.weatherButton.setImage(UIImage(named: weather.normal), for: .normal)
      }
    }
    
    viewModel.onDateChange = { [weak self] date in
      guard let self = self else { return }
      guard let date = date else { return }
      
      let dateString = date.toKoreanString()
      
      var config = self.dateLabelButton.configuration
      config?.title = dateString
      self.dateLabelButton.configuration = config
    }
    
    viewModel.onSave = { [weak self] in
      guard let self = self else { return }
      self.showWriteSuccessAlert()
    }
    
    viewModel.onUpdate = { [weak self] in
      guard let self = self else { return }
      self.showEditSuccessAlert()
    }
  }
}

// MARK: - Method
private extension WriteWeatherViewController {
  func makeImagePicker() -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.selectionLimit = 1
    config.filter = .images
    
    if #available(iOS 15.0, *) {
      config.selection = .ordered
      if shouldPreselect, let id = lastPickedAssetId {
        config.preselectedAssetIdentifiers = [id]
      } else {
        config.preselectedAssetIdentifiers = []
      }
    }
    
    let picker = PHPickerViewController(configuration: config)
    picker.modalPresentationStyle = .formSheet
    picker.delegate = self
    return picker
  }
  
  private func showWriteCancelAlert() {
    let (title, message): (String, String) = {
      switch mode {
      case .writeMode: return ("글쓰기를 그만 두시나요? 🥲", "작성된 글이 저장되지 않아요")
      case .editMode:  return ("수정을 취소하시나요? 🥲", "변경사항이 저장되지 않아요")
      }
    }()
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let exitAction = UIAlertAction(title: "나가기", style: .destructive) { _ in
      self.navigationController?.popViewController(animated: true)
    }
    let cancelAction = UIAlertAction(title: "계속하기", style: .default, handler: nil)
    alert.addAction(exitAction)
    alert.addAction(cancelAction)
    present(alert, animated: true)
  }
  
  func showWriteSuccessAlert() {
    let alert = UIAlertController(
      title: "작성 완료되었어요🌥️",
      message: "",
      preferredStyle: .alert
    )
    
    let continueAction = UIAlertAction(title: "확인", style: .default) { _ in
      self.navigationController?.popViewController(animated: true)
    }
    
    alert.addAction(continueAction)
    
    self.present(alert, animated: true)
  }
  
  func showEditSuccessAlert() {
    let alert = UIAlertController(
      title: "수정 완료되었어요🌤️",
      message: "",
      preferredStyle: .alert
    )
    
    let continueAction = UIAlertAction(title: "확인", style: .default) { _ in
      self.navigationController?.popViewController(animated: true)
    }
    
    alert.addAction(continueAction)
    
    self.present(alert, animated: true)
  }
  
  func applyModeInitialSetup() {
    switch mode {
    case .writeMode:
      let today = Date()
      viewModel.selectDate = today
      
      var config = dateLabelButton.configuration
      config?.title = today.toKoreanString()
      dateLabelButton.configuration = config
      
      toolbar.setAlignmentButton(viewModel.alignment)
      
    case .editMode(let existing):
      toolbar.setAlignmentButton(existing.alignment)
      viewModel.selectDate = existing.date
      var config = dateLabelButton.configuration
      config?.title = existing.date.toKoreanString()
      dateLabelButton.configuration = config
      
      writeView.text = existing.content
      viewModel.inputText = existing.content
      
      writeView.setTextAlignment(existing.alignment)
      viewModel.alignment = existing.alignment
      
      let weatherImage = UIImage(named: existing.weather) ?? .happy
      weatherButton.setImage(weatherImage, for: .normal)
      viewModel.selectedWeather = Weather(rawValue: existing.weather) ?? .happy
      
      if let data = existing.imageData, let img = UIImage(data: data) {
        writeView.configure(image: img)
        viewModel.imageData = data
      } else {
        writeView.configure(image: nil)
        viewModel.imageData = nil
      }
    }
  }
}

// MARK: - objc Method
private extension WriteWeatherViewController {
  @objc func setCalendarButtonTapped() {
    let vc = SelectDateModalViewController(viewModel: viewModel)
    self.present(vc, animated: true)
  }
  
  @objc func selectWeatherButtonTapped() {
    let vc = SelectWeatherModalViewController(viewModel: viewModel)
    self.present(vc, animated: true)
  }
}

// MARK: - Delegate
extension WriteWeatherViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    writeView.textViewDidChange(textView)
    viewModel.inputText = writeView.text
  }
  
  func textViewDidChangeSelection(_ textView: UITextView) {
    writeView.textViewDidChangeSelection(textView)
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == .g400 {
      textView.text = nil
      textView.textColor = .g700
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "오늘 감정 날씨는 어떤 풍경이었나요?"
      textView.textColor = .g400
    }
  }
}

extension WriteWeatherViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    
    guard let first = results.first else { return }
    
    if #available(iOS 15.0, *) {
      self.lastPickedAssetId = first.assetIdentifier
    }
    self.shouldPreselect = true
    
    guard first.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
    first.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] obj, error in
      guard let self = self, error == nil, let image = obj as? UIImage else { return }
      DispatchQueue.main.async {
        self.writeView.configure(image: image)
        self.viewModel.imageData = image.jpegData(compressionQuality: 0.85)
      }
    }
  }
}
