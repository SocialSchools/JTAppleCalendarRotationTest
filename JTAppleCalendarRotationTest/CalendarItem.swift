//
//  CalendarItems.swift
//  SocialSchools
//
//  Created by Jos van Velzen on 15/01/2018.
//  Copyright © 2018 Social Schools. All rights reserved.
//

import Foundation


struct CalendarItem: Codable {
    var id: Int
    var type: EventType
    var title: String
    var description: String?
    var location: String?
    var start: Date
    var end: Date
    var allDay: Bool
    
    var isSingleDay: Bool {
        return Calendar.current.isDate(self.start, inSameDayAs: self.end)
    }
    
    func isInDate(date: Date) -> Bool {
        let (start, end) = getDateRange(date)
        return self.start < end && self.end > start
    }
    
    func fits(inDate date: Date) -> Bool {
        let (start, end) = getDateRange(date)
        return start < self.start && end > self.end
    }
    
    func starts(inDate date: Date) -> Bool {
        let (start, end) = getDateRange(date)
        
        return start < self.start && self.start < end
    }
    
    func ends(inDate date: Date) -> Bool {
        let (start, end) = getDateRange(date)
        
        return start < self.end && self.end < end
    }
    
    func overlaps(date: Date) -> Bool {
        let (start, end) = getDateRange(date)
        
        return start > self.start && end < self.end
    }
    
    func getDateRange(_ date: Date) -> (Date, Date) {
        let start = date
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        
        return (start, end)
    }
}

enum EventType: Int, Codable {
    case undefined = 0
    case `default`
    case parentConversation
    case birthday
}

