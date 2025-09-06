//
//  TodayWeather.swift
//  TodaysWeather
//
//  Created by 여성일 on 9/6/25.
//
// TodayWeather.swift

import Foundation
import UIKit
import SwiftData

@Model
final class TodayWeather {
  @Attribute(.unique) var id: UUID
  var weather: String
  var date: Date
  var content: String
  var alignment: EditorAlignment
  var imageData: Data?
  var createdAt: Date
  var updatedAt: Date

  init(
    id: UUID = .init(),
    weather: String,
    date: Date,
    content: String,
    alignment: EditorAlignment = .left,
    imageData: Data? = nil,
    createdAt: Date = .now,
    updatedAt: Date = .now
  ) {
    self.id = id
    self.weather = weather
    self.date = date
    self.content = content
    self.alignment = alignment
    self.imageData = imageData
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}
