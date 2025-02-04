//
//  NewColorBasic.swift
//  pomodoro
//
//  Created by Daniel Silva on 03/02/25.
//

import SwiftUI

class NewColorBasic: DefaultColor {
    private var outerSpace: Color = Color(hex: "#CDB4DB")
    private var antiFlashWhite: Color = Color(hex: "#CC7585")
    private var cherryBlossomPink: Color = Color(hex: "#e9ecef")
    
    override func getPurple() -> Color {
        return outerSpace
    }
    
    override func getBg() -> Color {
        return antiFlashWhite
    }
    
    override func getDarkPurple() -> Color {
        return cherryBlossomPink
    }
}
