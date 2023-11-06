//
//  DefaultColor.swift
//  pomodoro
//
//  Created by Daniel Silva on 06/11/23.
//

import SwiftUI

class DefaultColor {
    
    private var purple: Color = Color("Purple")
    private var bg: Color = Color("BG")
    private var darkPurple: Color = Color("DarkPurple")
    
    func getPurple() -> Color {
        return purple
    }
    
    func getBg() -> Color {
        return bg
    }
    
    func getDarkPurple() -> Color {
        return darkPurple
    }
}
