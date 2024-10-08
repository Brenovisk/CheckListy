//
//  ListCardStatusIcon.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/10/24.
//

import SwiftUI

enum ListCardStatusIcon {

    case complete
    case favorite

}

extension ListCardStatusIcon {

    var value: some View {
        switch self {
        case .complete:
            IconsHelper.checkmark.value
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundColor(.accent)
        case .favorite:
            IconsHelper.star.value
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundColor(.yellowApp)
        }
    }

}
