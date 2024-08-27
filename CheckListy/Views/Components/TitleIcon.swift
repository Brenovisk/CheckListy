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
    var subtitle: String?
    
    var body: some View {
        HStack(alignment: .center) {
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
            
            HStack(alignment: .bottom) {
                Text(title)
                    .lineLimit(1)
                    .font(iconSize < 16 ? .headline : .largeTitle)
                    .fontWeight(.bold)
                
                if let subtitle {
                    Text(subtitle)
                        .font(iconSize < 16 ? .system(size: iconSize) : .headline)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.bottom, iconSize < 16 ? 2 : 5)
                }
            }
        }
    }
    
}

#Preview {
    TitleIcon(title: "List Name", icon: "house", color: Color(.red), iconSize: 12, subtitle: "1/15")
}
