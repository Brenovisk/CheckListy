//
//  ApplicationHelper.swift
//  CheckListy
//
//  Created by Breno Lucas on 06/11/24.
//

import Foundation
import SwiftUI
import UIKit

enum ApplicationHelper {

    static var rootViewController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }

        return root
    }

}
