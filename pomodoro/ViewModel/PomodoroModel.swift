//
//  PomodoroModel.swift
//  pomodoro
//
//  Created by Daniel Silva on 05/11/23.
//

import SwiftUI

class PomodoroModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // MARK: timer properties
    @Published var progress: CGFloat = 1
    @Published var timeStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    @Published var isPaused: Bool = false
    
    @Published var hour: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    // MARK: Total Seconds
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    // MARK: Post timer properties
    @Published var isFinished: Bool = false
    
    // Since Its NSObject
    override init() {
        super.init()
        self.authorizeNotification()
    }
    
    // MARK: Requesting Notification Access
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in
        }
        
        // MARK: To Show In App Notification
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    // MARK: Starting timer
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)) { isStarted = true
            // MARK: Setting String Time Value
            timeStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
            
            // MARK: Calculating Total Seconds For Timer Animation
            totalSeconds = (hour * 3600) + (minutes * 60) + seconds
            staticTotalSeconds = totalSeconds
            addNewTimer = false
            addNotification()
            
        }
    }
    
    // MARK: Stopping timer
    func stopTimer() {
        withAnimation {
            isStarted = false
            hour = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        
        totalSeconds = 0
        staticTotalSeconds = 0
        timeStringValue = "00:00"
    }
    
    // MARK: Updating time
    func updateTimer() {
        totalSeconds  -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        // MARK: 60 minutes * 60 seconds
        hour = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        timeStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        if hour == 0 && minutes == 0 && seconds == 0 {
            isStarted = false
            print("Finished")
            isFinished = true
        }
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Timer"
        content.subtitle = "Congratulations You did it hooray 🥳🥳🥳"
        content.sound = UNNotificationSound.defaultRingtone
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: Desable or Enable Save Button
    func desableOrEnable() -> Bool {
        return hour == 0 && minutes == 0 && seconds == 0
    }
    
    // MARK: Pause Pomodoro Timer
    func pauseTimer() {
        withAnimation {
            isStarted = false
            isPaused = true
        }
    }
    
    // MARK: Finished Pause timer
    func finishedPause() {
        withAnimation {
            isStarted = true
            isPaused = false
        }
    }
}

