//
//  DateFormatter.swift
//  NewsAPP
//
//  Created by Jason on 6/4/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import Foundation

class DateManipulator {
    
    private init() {
        decodeToDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        encodeToStringFormatter.dateFormat = "EEEE,d MMM yyyy hh:mm a zzz"
    }
    let decodeToDateFormatter = DateFormatter()
    let encodeToStringFormatter = DateFormatter()
    static var shared: DateManipulator?
    static func getInstance() -> DateManipulator {
        if shared == nil {
            shared = DateManipulator()
        }
        return shared!
    }
}

