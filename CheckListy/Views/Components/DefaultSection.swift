//
//  DefaultSection.swift
//  CheckListy
//
//  Created by Breno Lucas on 01/08/24.
//

import Foundation
import SwiftUI

struct DefaultSection<Content: View>: View {
    
    var title: String
    var content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title.uppercased())
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(0)
                .foregroundColor(Color(.lightGray))
            
            VStack {
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .section(padding: 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}
