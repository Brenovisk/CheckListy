//
//  ShareSheet.swift
//  CheckListy
//
//  Created by Breno Lucas on 31/07/24.
//

import Foundation
import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context _: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_: UIActivityViewController, context _: Context) {}
}
