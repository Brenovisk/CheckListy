//
//  HeaderSection.swift
//  CheckListy
//
//  Created by Breno Lucas on 22/07/24.
//

import Foundation
import SwiftUI

struct HeaderSection<Item: Hashable>: View {
    
    var section: SectionModel<Item>
    var onAdd: ((SectionModel<Item>) -> Void)?
    var onCollapse: ((SectionModel<Item>) -> Void)?
    var subtitle: String?
    var icon: String?
    var enableAdd: Bool = true
    var enableCollapse: Bool = true
    
    private init(section: SectionModel<Item>, subtitle: String? = nil, icon: String? = nil, enableAdd: Bool = true, enableCollapse: Bool = true, onAdd: ((SectionModel<Item>) -> Void)?, onCollapse: ((SectionModel<Item>) -> Void)?) {
        self.init(section: section, subtitle: subtitle, icon: icon, enableAdd: enableAdd, enableCollapse: enableCollapse)
        self.onAdd = onAdd
        self.onCollapse = onCollapse
    }
    
    init(section: SectionModel<Item>, subtitle: String? = nil, icon: String? = nil, enableAdd: Bool = true, enableCollapse: Bool = true) {
        self.section = section
        self.subtitle = subtitle
        self.icon = icon
        self.enableAdd = enableAdd
        self.enableCollapse = enableCollapse
    }

    var body: some View {
        HStack {
            if let icon {
                Image(systemName: icon)
                    .foregroundColor(Color(.lightGray))
            }
            
            if !section.name.isEmpty {
                Text(section.name.uppercased())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(0)
                    .foregroundColor(Color(.lightGray))
                
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(Color(.lightGray))
                }
                
                Spacer()
                
                HStack(spacing: 24) {
                    if enableAdd {
                        Button(action: { onAdd?(section) }) {
                            Image(systemName: "plus")
                        }
                    }
                    
                    if enableCollapse {
                        Button(action: { onCollapse?(section) }) {
                            Image(systemName: "chevron.right")
                                .rotationEffect(section.collapsed ? .zero : .degrees(90))
                        }
                    }
                }
            }
        }
        .padding(.bottom, section.collapsed ? 16 : 0)
        .frame(alignment: .center)
        .font(.headline)
    }
}

// MARK: - Callbacks modifiers
extension HeaderSection {
    
    func `onAdd`(action: ((SectionModel<Item>) -> Void)?) -> HeaderSection {
        HeaderSection(
            section: self.section,
            subtitle: self.subtitle,
            icon: self.icon,
            enableAdd: self.enableAdd,
            enableCollapse: self.enableCollapse, 
            onAdd: action,
            onCollapse: self.onCollapse
        )
    }
    
    func `onCollapse`(action: ((SectionModel<Item>) -> Void)?) -> HeaderSection {
        HeaderSection(
            section: self.section,
            subtitle: self.subtitle,
            icon: self.icon,
            enableAdd: self.enableAdd,
            enableCollapse: self.enableCollapse,
            onAdd: self.onAdd,
            onCollapse: action
        )
    }
    
}

#Preview {
    HeaderSection(
        section: SectionModel<ListItemModel>(
            name: "Section name",
            items: []
        ),
        subtitle: "1/5",
        icon: "star"
    )
}
