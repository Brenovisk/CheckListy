//
//  String+ConvertToBase64.swift
//  CheckListy
//
//  Created by Breno Lucas on 31/07/24.
//

import Foundation

extension String {
    
    func toBase64Code() -> String {
        let data = self.data(using: .utf8)!
        return data.base64EncodedString()
    }
    
    func fromBase64Code() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(decoding: data, as: UTF8.self)
    }
    
    func addingSuffix(_ suffix: String) -> String {
        self + suffix
    }
    
    func removingSuffix(_ suffix: String) -> String {
        if self.hasSuffix(suffix) {
            return String(self.dropLast(suffix.count))
        } else {
            return self
        }
    }
    
}
