//
//  TimeService.swift
//  CheckListy
//
//  Created by Breno Lucas on 24/09/24.
//

import Foundation

class TimeService {

    static func getPeriodDay() -> PeriodsDay {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())

        switch hour {
        case 6 ..< 12:
            return .morning
        case 12 ..< 18:
            return .afternoon
        case 18 ..< 24:
            return .evening
        default:
            return .night
        }
    }

}
