//
//  ShareSheet.swift
//  CheckListy
//
//  Created by Breno Lucas on 31/07/24.
//

import Foundation
import UIKit
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
}
