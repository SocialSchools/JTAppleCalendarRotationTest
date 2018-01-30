//
//  CalendarViewCell.swift
//  SocialSchools
//
//  Created by Jos van Velzen on 12/01/2018.
//  Copyright © 2018 Social Schools. All rights reserved.
//

import JTAppleCalendar
import UIKit

class CalendarViewCell: JTAppleCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var hasItemsLabel: UILabel!
    
    static let dateFont = UIFont.systemFont(ofSize: 10)
    static let selectedDateFont = UIFont.systemFont(ofSize: 10, weight: .heavy)
    
    var hasItems: Bool = false {
        didSet {
            self.hasItemsLabel.isHidden = !self.hasItems
        }
    }
    
    func setup(calendar: Calendar, cellState: CellState, date: Date) {
        let tintColor = UIColor.blue
        let derivedTintColor = UIColor.green
        
        if cellState.isSelected {
            self.dateLabel.textColor = .white
            self.dateLabel.font = CalendarViewCell.selectedDateFont
            self.backgroundColor = tintColor
        } else if calendar.isDateInToday(date) {
            self.dateLabel.textColor = tintColor
            self.dateLabel.font = CalendarViewCell.selectedDateFont
            self.backgroundColor = derivedTintColor
        } else {
            self.dateLabel.font = CalendarViewCell.dateFont
            
            if cellState.dateBelongsTo == .thisMonth {
                self.dateLabel.textColor = UIColor.black
                self.backgroundColor = .white
            } else {
                self.dateLabel.textColor = .gray
                self.backgroundColor = UIColor.lightGray
            }
        }
    }
}

