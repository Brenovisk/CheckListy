//
//  TitleIcon.swift
//  CheckListy
//
//  Created by Breno Lucas on 15/07/24.
//

import Foundation
import SwiftUI

struct TitleIcon: View {
    
    var title: String = String()
    var icon: String?
    var color: Color?
    var iconSize: CGFloat = 16
    
    var body: some View {
        HStack {
            if let icon, let color {
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 2 * iconSize, height: 2 * iconSize)
                    
                    
                    Image(systemName: icon)
                        .foregroundColor(Color.black)
                        .font(.system(size: iconSize))
                    
                }
            }
            
            Text(title)
                .font(iconSize < 16 ? .headline : .largeTitle)
                .fontWeight(.bold)
        }
    }
    
}
