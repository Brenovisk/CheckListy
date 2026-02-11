//
//  CircularProgressBar.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/10/24.
//

import SwiftUI

struct CircularProgressBar: View {

    var progress: Double
    var color: Color
    var lineWidth: CGFloat
    var size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundColor(.white)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: progress)
        }
        .frame(width: size, height: size)
    }
}

struct ContentViewCircularProgressBar: View {

    @State private var progress: Double = 0.5

    var body: some View {
        VStack {
            CircularProgressBar(progress: progress, color: .blue, lineWidth: 10, size: 40)
                .frame(width: 150, height: 150)

            Slider(value: $progress)
                .padding()

            HStack {
                Button(action: {
                    withAnimation {
                        progress = 0.25
                    }
                }) {
                    Text("25%")
                }
                Button(action: {
                    withAnimation {
                        progress = 0.75
                    }
                }) {
                    Text("75%")
                }
                Button(action: {
                    withAnimation {
                        progress = 1.0
                    }
                }) {
                    Text("100%")
                }
            }
            .padding(.top, 20)
        }
        .background(.black)
    }

}

#Preview {
    ContentViewCircularProgressBar()
}
