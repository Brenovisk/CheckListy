//
//  ConvertibleDictionary.swift
//  CheckListy
//
//  Created by Breno Lucas on 05/08/24.
//

import Foundation

protocol ConvertibleDictionary {
    
    func toNSDictionary() -> NSDictionary
    static func fromNSDictionary(_ dictionary: NSDictionary) -> Self?
    
}
