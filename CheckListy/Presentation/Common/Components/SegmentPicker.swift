//
//  SegmentPicker.swift
//  CheckListy
//
//  Created by Breno Lucas on 03/10/24.
//

import SwiftUI

struct SegmentPicker: View {

    @Binding var selectedIndex: Int
    let segments: [SegmentCustom]

    var body: some View {
        ForEach(Array(segments.enumerated()), id: \.element) { index, segment in

            HStack {
                Group {
                    if index == selectedIndex {
                        Text(String(segment.number))
                    } else {
                        segment.icon
                    }
                }
                .foregroundColor(getColor(segment, with: index))

                Text(segment.title.uppercased())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(0)
                    .foregroundColor(getColor(segment, with: index))
            }

            .padding(.trailing, 16)
            .onTapGesture {
                withAnimation {
                    selectedIndex = index
                }
            }
        }
        .scrollHorizontal(padding: 16)
    }
}

// MARK: Helper Methods
extension SegmentPicker {

    private func getColor(_ segment: SegmentCustom, with index: Int) -> Color {
        index == selectedIndex ? segment.color : Color(.lightGray)
    }

}

struct SegmentPickerContentView: View {

    @State private var selectedSegmentIndex = 0

    let segmentOptions = [
        SegmentCustom(
            title: "Segment 1",
            icon: IconsHelper.clock.value,
            color: .blue
        ) {
            Text("Segment 1")
        },
        SegmentCustom(
            title: "Segment 2",
            icon: IconsHelper.personFill.value,
            color: .green
        ) {
            Text("Segment 2")
        },
        SegmentCustom(
            title: "Segment 3",
            icon: IconsHelper.eyeFill.value,
            color: .red
        ) {
            Text("Segment 3")
        }
    ]

    var body: some View {
        VStack {
            segmentOptions[selectedSegmentIndex].content
                .padding()

            SegmentPicker(
                selectedIndex: $selectedSegmentIndex,
                segments: segmentOptions
            )
        }
    }

}

#Preview {
    SegmentPickerContentView()
}
