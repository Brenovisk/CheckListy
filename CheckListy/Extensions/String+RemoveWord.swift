//
//  String+RemoveWord.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Foundation

extension String {
    
    func remove(_ word: String) -> String {
        self.replacingOccurrences(of: word, with: "")
    }
    
}
