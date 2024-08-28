//
//  PopupHelper.swift
//  CheckListy
//
//  Created by Breno Lucas on 20/08/24.
//

import Foundation
import SwiftUI

enum PopupTypes {
    case error
    case warning
    case success
}

extension PopupTypes {
    var value: PopupType {
        switch self {
        case .error:
            return PopupType(
                color: .red,
                icon: Image(systemName: "xmark.circle")
            )
        case .warning:
            return PopupType(
                color: .orange,
                icon: Image(systemName: "exclamationmark.circle")
            )
        case .success:
            return PopupType(
                color: .green,
                icon: Image(systemName: "checkmark.circle")
            )
        }
    }
}
