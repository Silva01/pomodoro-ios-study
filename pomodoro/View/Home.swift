//
//  Home.swift
//  pomodoro
//
//  Created by Daniel Silva on 05/11/23.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var pomodoroModel: PomodoroModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var navigateToTask = false
    
    var defaultColor: NewColorBasic = .init()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Pomotron Timer")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                GeometryReader { proxy in
                    
                    let isLandscape = proxy.size.width > proxy.size.height
                    
                    VStack (spacing: 15) {
                        // MARK: Timer ring
                        ZStack {
                            
                            Circle()
                                .fill(.white.opacity(0.03))
                                .padding(-40)
                            
                            Circle()
                                .trim(from: 0, to: pomodoroModel.progress)
                                .stroke(.white.opacity(0.03), lineWidth: 80)
                            
                            // MARK: Shadow
                            Circle()
                                .stroke(defaultColor.getPurple(), lineWidth: 5)
                                .blur(radius: 15)
                                .padding(-2)
                            
                            Circle()
                                .fill(defaultColor.getBg())
                            
                            Circle()
                                .trim(from: 0, to: pomodoroModel.progress)
                                .stroke(defaultColor.getPurple().opacity(0.7), lineWidth: 10)
                            
                            // MARK: Knob
                            GeometryReader { proxy in
                                let size = proxy.size
                                
                                Circle()
                                    .fill(defaultColor.getPurple())
                                    .frame(width: 30, height: 30)
                                    .overlay(content: {
                                        Circle()
                                            .fill(.white)
                                            .padding(5)
                                    })
                                    .frame(width: size.width, height: size.height, alignment: .center)
                                // MARK: Since View is Rotated Thats Why Using X
                                    .offset(x: size.height / 2)
                                    .rotationEffect(.init(degrees: pomodoroModel.progress * 360))
                                
                            }
                            
                            Text(pomodoroModel.timeStringValue)
                                .font(.system(size: 45, weight: .light))
                                .rotationEffect(.init(degrees: 90))
                                .animation(.none, value: pomodoroModel.progress)
                        }
                        .padding(60)
                        .frame(height: proxy.size.width)
                        .rotationEffect(.init(degrees: -90))
                        .animation(.easeInOut, value: pomodoroModel.progress)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        
                        
                        HStack {
                            Button {
                                
                                if pomodoroModel.isStarted {
                                    pomodoroModel.stopTimer()
                                    // MARK: Cancelling All Notifications
                                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                } else {
                                    pomodoroModel.addNewTimer = true
                                }
                                
                            } label: {
                                Image(systemName: !pomodoroModel.isStarted ? "timer" : "stop.fill")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 80)
                                    .background {
                                        Circle()
                                            .fill(defaultColor.getPurple())
                                    }
                                    .shadow(color: defaultColor.getPurple(), radius: 8, x: 0, y: 0)
                            }
                            .offset(x: pomodoroModel.isStarted || !pomodoroModel.desableOrEnable() ? -20 : 0)
                            
                            
                            if !pomodoroModel.desableOrEnable() {
                                Button {
                                    
                                    if pomodoroModel.isPaused {
                                        pomodoroModel.finishedPause()
                                    } else {
                                        pomodoroModel.pauseTimer()
                                    }
                                    
                                } label: {
                                    Image(systemName: !pomodoroModel.isPaused ? "play" : "pause")
                                        .font(.largeTitle.bold())
                                        .foregroundColor(.white)
                                        .frame(width: 80, height: 80)
                                        .background {
                                            Circle()
                                                .fill(defaultColor.getPurple())
                                        }
                                        .shadow(color: defaultColor.getPurple(), radius: 8, x: 0, y: 0)
                                }
                                .offset(x: 20)
                            }
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                    .scaleEffect(isLandscape ? 0.36 : 1.0)
                }
            }
            .padding()
            .background {
                defaultColor.getBg()
                    .ignoresSafeArea()
            }
            .overlay(content: {
                ZStack {
                    Color.black
                        .opacity(pomodoroModel.addNewTimer ? 0.25 : 0)
                        .onTapGesture {
                            pomodoroModel.hour = 0
                            pomodoroModel.minutes = 0
                            pomodoroModel.seconds = 0
                            pomodoroModel.addNewTimer = false
                        }
                    
                    NewTimerView()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: pomodoroModel.addNewTimer ? 0 : 400)
                }
                .animation(.easeInOut, value: pomodoroModel.addNewTimer)
            })
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                if pomodoroModel.isStarted {
                    pomodoroModel.updateTimer()
                }
            }
            .alert("Congratulations You did it hooray 🥳🥳🥳", isPresented: $pomodoroModel.isFinished) {
                Button("Start New", role: .cancel) {
                    pomodoroModel.stopTimer()
                    pomodoroModel.addNewTimer = true
                }
                
                Button("Close", role: .destructive) {
                    pomodoroModel.stopTimer()
                }
            }

        }
    }
    
    @ViewBuilder
    func NewTimerView() -> some View {
        VStack(spacing: 15) {
            Text("Add New Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
            
            HStack(spacing: 15) {
                Text("\(pomodoroModel.hour) hr")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 12, hint: "hr") { value in
                            pomodoroModel.hour = value
                        }
                    }
                
                Text("\(pomodoroModel.minutes) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 59, hint: "min") { value in
                            pomodoroModel.minutes = value
                        }
                    }
                
                Text("\(pomodoroModel.seconds) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 59, hint: "sec") { value in
                            pomodoroModel.seconds = value
                        }
                    }
            }
            .padding(.top, 20)
            
            Button {
                pomodoroModel.startTimer()
            } label: {
                Text("Start!")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background {
                        Capsule()
                            .fill(defaultColor.getPurple())
                    }
            }
            .disabled(pomodoroModel.desableOrEnable())
            .opacity(pomodoroModel.desableOrEnable() ? 0.5 : 1)
            .padding(.top)
            
//            NavigationLink("Go to Task", destination: TaskView())
//                .font(.title3)
//                .fontWeight(.semibold)
//                .foregroundColor(.white)
//                .padding(.vertical)
//                .padding(.horizontal, 100)
//                .background {
//                    Capsule()
//                        .fill(defaultColor.getPurple())
//                }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(defaultColor.getBg())
                .ignoresSafeArea()
        }
    }
    
    // MARK: Reusable Context Menu Options
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> some View {
        ForEach(0...maxValue, id: \.self) { value in
            Button("\(value) \(hint)") {
                onClick(value)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PomodoroModel())
}
