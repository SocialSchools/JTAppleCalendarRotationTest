//
//  CalendarStore.swift
//  SocialSchools
//
//  Created by Jos van Velzen on 15/01/2018.
//  Copyright © 2018 Social Schools. All rights reserved.
//

import Foundation


class CalendarStore {
    let items: [CalendarItem]
    
    init (items: [CalendarItem] = [CalendarItem]()) {
        self.items = items
    }
    
    func containsItems(for date: Date) -> Bool {
        let items = self.items.filter { $0.isInDate(date: date) }
        
        return !items.isEmpty
    }
    
    func items(for date: Date) -> [CalendarItem] {
        let items = self.items.filter { $0.isInDate(date: date) }
        
        return items
    }
}
