//
//  HeaderSection.swift
//  CheckListy
//
//  Created by Breno Lucas on 22/07/24.
//

import Foundation
import SwiftUI

struct HeaderSection: View {
    
    var section: SectionModel
    var onAdd: ((SectionModel) -> Void)?
    var onCollapse: ((SectionModel) -> Void)?
    var subtitle: String?
    
    private init(section: SectionModel, subtitle: String? = nil, onAdd: ((SectionModel) -> Void)?, onCollapse: ((SectionModel) -> Void)?) {
        self.init(section: section, subtitle: subtitle)
        self.onAdd = onAdd
        self.onCollapse = onCollapse
    }
    
    init(section: SectionModel, subtitle: String? = nil) {
        self.section = section
        self.subtitle = subtitle
    }

    var body: some View {
        HStack {
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
                    Button(action: { onAdd?(section) }) {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: { onCollapse?(section) }) {
                        Image(systemName: "chevron.right")
                            .rotationEffect(section.collapsed ? .zero : .degrees(90))
                    }
                }
            }
        }
        .padding(.bottom, section.collapsed ? 16 : 0)
        .frame(alignment: .center)
        .font(.headline)
    }
}

//MARK: - Callbacks modifiers
extension HeaderSection {
    
    func `onAdd`(action: ((SectionModel) -> Void)?) -> HeaderSection {
        HeaderSection(
            section: self.section,
            subtitle: self.subtitle,
            onAdd: action,
            onCollapse: self.onCollapse
        )
    }
    
    func `onCollapse`(action: ((SectionModel) -> Void)?) -> HeaderSection {
        HeaderSection(
            section: self.section,
            subtitle: self.subtitle,
            onAdd: self.onAdd,
            onCollapse: action
        )
    }
    
}

#Preview {
    HeaderSection(section: SectionModel(name: "Section name", items: []), subtitle: "1/5")
}
