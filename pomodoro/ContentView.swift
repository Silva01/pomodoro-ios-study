//
//  ContentView.swift
//  pomodoro
//
//  Created by Daniel Silva on 05/11/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    var body: some View {
        Home()
            .environmentObject(pomodoroModel)
    }
}

#Preview {
    ContentView()
}
