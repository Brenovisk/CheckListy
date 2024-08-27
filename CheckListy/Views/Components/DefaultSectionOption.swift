//
//  DefaultSectionOption.swift
//  CheckListy
//
//  Created by Breno Lucas on 01/08/24.
//

import Foundation
import SwiftUI

struct DefaultSectionOption: View {
    
    var title: String
    var icon: String?
    var navigable: Bool = false
    var destructive: Bool = false
    
    var onPress: (() -> Void)?
    
    private init(title: String, icon: String? = nil, navigable: Bool = false, destructive: Bool = false, onPress: (() -> Void)?) {
        self.init(title: title, icon: icon, navigable: navigable, destructive: destructive)
        self.onPress = onPress
    }
    
    init(title: String, icon: String? = nil, navigable: Bool = false, destructive: Bool = false) {
        self.title = title
        self.icon = icon
        self.navigable = navigable
        self.destructive = destructive
    }
    
    var body: some View {
        Button(action: { onPress?() }) {
            HStack {
                if let icon {
                    Image(systemName: icon)
                        .imageScale(.small)
                }
                
                Text(title)
                    .font(.body)
                
                Spacer()
                
                if navigable {
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                }
            }.foregroundColor(destructive ? .red : .primary)
        }
    }
    
}

extension DefaultSectionOption {
    
    func `onPress`(action: (() -> Void)?) -> DefaultSectionOption {
        DefaultSectionOption(
            title: self.title,
            icon: self.icon,
            navigable: self.navigable,
            destructive: self.destructive,
            onPress: action
        )
    }
    
}
