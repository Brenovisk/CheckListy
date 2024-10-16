//
//  TimeService.swift
//  CheckListy
//
//  Created by Breno Lucas on 24/09/24.
//

import Foundation

class TimeService {

    var dateFormatter = DateFormatter()

    static let defaultFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let defaultTimezone = TimeZone(abbreviation: "UTC")
    static let defaultLocale = Locale.current

    init() {
        dateFormatter.dateFormat = TimeService.defaultFormat
        dateFormatter.timeZone = TimeService.defaultTimezone
        dateFormatter.locale = TimeService.defaultLocale
    }

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

    func getDateString(from date: Date, format: String? = nil, timezone: TimeZone? = nil, locale: Locale? = nil) -> String {
        dateFormatter.dateFormat = format ?? TimeService.defaultFormat
        dateFormatter.timeZone = timezone ?? TimeService.defaultTimezone
        dateFormatter.locale = locale ?? TimeService.defaultLocale

        return dateFormatter.string(from: date)
    }

    func convertToDate(string: String) -> Date? {
        guard let date = dateFormatter.date(from: string) else {
            return nil
        }

        return date
    }

}
