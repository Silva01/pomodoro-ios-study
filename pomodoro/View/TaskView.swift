//
//  TaskView.swift
//  pomodoro
//
//  Created by Daniel Silva on 02/02/25.
//

import SwiftUI

struct TaskView: View {
    var body: some View {
        VStack {
            Text("Minhas Tarefas")
                .font(.title.bold())
                .foregroundColor(.white)
            
            GeometryReader { proxy in
                
            }
        }
        .background(Color("BG"))
    }
}

#Preview {
    TaskView()
}
