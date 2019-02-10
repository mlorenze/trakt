//
//  DateFormatter+Trakt.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        //        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        //        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

}
