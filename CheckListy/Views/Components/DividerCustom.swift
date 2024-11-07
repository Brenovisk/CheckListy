//
//  DividerCustom.swift
//  CheckListy
//
//  Created by Breno Lucas on 22/10/24.
//

import SwiftUI

struct DividerCustom: View {

    var color: Color = .gray
    var thickness: CGFloat = 1
    var isVertical: Bool = false

    var body: some View {
        if isVertical {
            Rectangle()
                .fill(color)
                .frame(width: thickness, height: .infinity)
        } else {
            Rectangle()
                .fill(color)
                .frame(height: thickness)
                .frame(maxWidth: .infinity)
        }
    }

}

#Preview {
    DividerCustom()
}
