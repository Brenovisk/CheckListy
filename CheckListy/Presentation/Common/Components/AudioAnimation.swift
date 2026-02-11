//
//  AudioAnimation.swift
//  CheckListy
//
//  Created by Breno Lucas on 21/07/24.
//

import Foundation
import SwiftUI

struct AudioAnimation: View {
    @State private var drawingHeight = true
    var color: Color = .indigo

    var animation: Animation {
        .linear(duration: 0.5).repeatForever()
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(0 ..< 6) { _ in
                    bar(low: 0.4)
                        .animation(animation.speed(1.5), value: drawingHeight)
                    bar(low: 0.3)
                        .animation(animation.speed(1.2), value: drawingHeight)
                    bar(low: 0.5)
                        .animation(animation.speed(1.0), value: drawingHeight)
                    bar(low: 0.3)
                        .animation(animation.speed(1.7), value: drawingHeight)
                    bar(low: 0.5)
                        .animation(animation.speed(1.0), value: drawingHeight)
                }
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                drawingHeight.toggle()
            }
        }
    }

    func bar(low: CGFloat = 0.0, high: CGFloat = 1.0) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(color)
            .frame(height: (drawingHeight ? high : low) * 48)
            .frame(height: 64, alignment: .center)
    }
}

#Preview {
    AudioAnimation()
}
