//
//  DateFormatter.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public extension DateFormatter {
    class func UTCToLocal(date: String, fromFormat: String, toFormat: String, locale: Locale) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt: Date! = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        dateFormatter.locale = locale

        return dateFormatter.string(from: dt)
    }
    
    class func mapHistoryDate(date: Date) -> String {
        let dateFormatterPrint = DateFormatter()
        let format = "dd MMM yyyy h:mm a"
        let format24 = "dd MMM yyyy HH:mm"

        let locale = Locale.current
        let toFormat = DateFormatter.dateFormat(fromTemplate: "ddMMMyyyyjmm", options: 0, locale: locale)

        dateFormatterPrint.dateFormat = format
        let entityDate = dateFormatterPrint.string(from: date)
        
        let localDateAsString = DateFormatter.UTCToLocal(date: entityDate,
                                                         fromFormat: format,
                                                         toFormat: toFormat ?? format24,
                                                         locale: locale)
        
        return localDateAsString
    }
}
