//
//  Segment.swift
//  CheckListy
//
//  Created by Breno Lucas on 03/10/24.
//

import SwiftUI

struct SegmentCustom: Hashable, Equatable {

    var id: UUID = .init()
    var title: String
    var icon: Image
    var content: AnyView
    var color: Color
    var number: Int

    init(title: String, icon: Image, color: Color, number: Int = 0, @ViewBuilder content: () -> any View) {
        self.title = title
        self.icon = icon
        self.content = AnyView(content())
        self.color = color
        self.number = number
    }

    static func == (lhs: SegmentCustom, rhs: SegmentCustom) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.icon == rhs.icon &&
            lhs.color == rhs.color
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(color)
    }

}
