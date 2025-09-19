//
//  SceneDelegate.swift
//  TodaysWeather
//
//  Created by 여성일 on 8/20/25.
//

import UIKit
import SwiftData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  private(set) var modelContainer: ModelContainer!
  private(set) var modelContext: ModelContext!
  
  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    do {
      let config = ModelConfiguration(isStoredInMemoryOnly: false)
      modelContainer = try ModelContainer(for: TodayWeather.self, configurations: config)
      modelContext = ModelContext(modelContainer)
      modelContext.autosaveEnabled = true
    } catch {
      assertionFailure("ModelContainer init Error")
      return
    }
    
    let splashVC = SplashViewController()
    let nav = UINavigationController(rootViewController: splashVC)
    
    let window = UIWindow(windowScene: windowScene)
    window.overrideUserInterfaceStyle = .light
    self.window = window
    window.rootViewController = nav
    window.makeKeyAndVisible()
    
    var splashMinimumDelayFinished = false
    var dataLoadFinished = false
    
    func tryTransition() {
      if splashMinimumDelayFinished && dataLoadFinished {
        let mainVC = MainViewController(modelContext: self.modelContext)
        nav.setViewControllers([mainVC], animated: true)
      }
    }
    
    splashVC.onFinished = {
      splashMinimumDelayFinished = true
      tryTransition()
    }
    
    DispatchQueue.global().async {
      do {
        var descriptor = FetchDescriptor<TodayWeather>()
        descriptor.fetchLimit = 1
        let _ = try self.modelContext.fetch(descriptor)
        
        DispatchQueue.main.async {
          dataLoadFinished = true
          tryTransition()
        }
      } catch {
        print("초기 데이터 fetch 실패: \(error)")
        DispatchQueue.main.async {
          dataLoadFinished = true
          tryTransition()
        }
      }
    }
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
  
  
}

