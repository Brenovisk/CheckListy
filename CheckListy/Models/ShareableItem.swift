//
//  ShareableItem.swift
//  CheckListy
//
//  Created by Breno Lucas on 31/07/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ShareableItem: Transferable, Codable {
    
    let id: UUID
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: ShareableItem.self, contentType: .shareableItem)
    }
    
}

extension UTType {
    
    static var shareableItem: UTType {
        UTType(exportedAs: "com.alecrimLabs.checkListy")
    }
    
}
