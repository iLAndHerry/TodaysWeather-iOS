//
//  WriteWeatherViewModel.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/21/25.
//

import Foundation
import SwiftData

final class WriteWeatherViewModel {
  // MARK: - State
  private let modelContext: ModelContext
  
  var selectedWeather: Weather = .happy {
    didSet { onWeatherChange?(selectedWeather) }
  }
  
  var selectDate: Date? {
    didSet { onDateChange?(selectDate) }
  }
  
  var inputText: String = "" {
    didSet { onTextChange?(inputText) }
  }
  
  var imageData: Data? {
    didSet { onImageChange?(imageData) }
  }
  
 var alignment: EditorAlignment = .left
  
  // MARK: - Outputs (callbacks)
  var onWeatherChange: ((Weather) -> Void)? {
    didSet { onWeatherChange?(selectedWeather) }
  }
  
  var onDateChange: ((Date?) -> Void)? {
    didSet { onDateChange?(selectDate) }
  }
  
  var onTextChange: ((String) -> Void)?
  var onImageChange: ((Data?) -> Void)?
  var onSave: (() -> Void)?
  var onUpdate: (() -> Void)?

  init(modelContext: ModelContext) {
    self.modelContext = modelContext
    self.selectDate = Date()
  }
  
  func save() {
    let now = Date()
    
    let model = TodayWeather(
      weather: selectedWeather.rawValue,
      date: selectDate ?? now,
      content: inputText,
      alignment: alignment,
      imageData: imageData,
      createdAt: now,
      updatedAt: now
    )
    
    modelContext.insert(model)
    
    do {
      print("저장성공")
      try modelContext.save()
      onSave?()
    } catch {
      print("저장에러")
    }
  }
  
  func update(existing: TodayWeather) {
    existing.content = inputText
    existing.date = selectDate ?? existing.date
    existing.alignment = alignment
    existing.weather = selectedWeather.rawValue
    existing.imageData = imageData
    
    do {
      print("업데이트 성공")
      try modelContext.save()
      onUpdate?()
    } catch {
      print("업데이트 에러")
    }
  }
}

