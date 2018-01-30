//
//  ViewController.swift
//  JTAppleCalendarRotationTest
//
//  Created by Jos van Velzen on 30/01/2018.
//  Copyright © 2018 Social Schools. All rights reserved.
//

import JTAppleCalendar
import UIKit

class ViewController: UIViewController {
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var selectedDateLabel: UILabel!
    
    var selectedDate: Date = Date() {
        didSet {
            self.setSelectedDateLabel()
        }
    }
    var calendar = Calendar.current
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    var calendarStore: CalendarStore = CalendarStore()
    
    @IBAction func previous(_ sender: Any) {
        self.calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func next(_ sender: Any) {
        self.calendarView.scrollToSegment(.next)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setSelectedDateLabel()

        self.setupCalendar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if self.calendarView != nil {
            let theDate = self.selectedDate
            NSLog("anchorDate: \(theDate)")
            self.calendarView.viewWillTransition(to: size, with: coordinator, anchorDate: theDate)
        }
    }
    
    func setSelectedDateLabel() {
        self.selectedDateLabel.text = self.formatter.string(from: self.selectedDate)
    }
    
    func setupCalendar() {
        self.calendarView.selectDates([self.selectedDate], triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: false)
        
        self.calendarView.scrollingMode = .stopAtEachSection
        self.calendarView.scrollToDate(self.selectedDate, animateScroll: false)
    }
    
    func setupViewsOfCalendar(for visibleDates: DateSegmentInfo) {
        guard
            let startDate = visibleDates.monthDates.first?.date,
            let month = self.calendar.dateComponents([.month], from: startDate).month else {
                return
        }
        
        let monthName = self.formatter.monthSymbols[(month-1) % 12].uppercased()
        // 0 indexed array
        let year = self.calendar.component(.year, from: startDate)
        monthLabel.text = "\(monthName) \(year)"
        
        self.loadCalendarItems(for: visibleDates)
    }
    
    func loadCalendarItems(for visibleDates: DateSegmentInfo) {
        var date = Date()
        var items = [CalendarItem]()
        
        for i in 1...30 {
            date = self.calendar.date(byAdding: .day, value: 1, to: date)!
            let end = self.calendar.date(byAdding: .hour, value: 1, to: date)!
            
            let item = CalendarItem(id: i, type: .default, title: "Item \(i)", description: "item  \(i) desc", location: "Location  \(i)", start: date, end: end, allDay: false)
            items.append(item)
        }
        self.calendarStore = CalendarStore(items: items)
        self.calendarView.reloadData()
    }
}

extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        self.handleCellConfiguration(cell: cell, cellState: cellState, date: date)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let current = Date()
        guard
            let startDate = self.calendar.date(byAdding: .year, value: -1, to: current),
            let endDate = self.calendar.date(byAdding: .year, value: 2, to: current) else {
                fatalError("Dates could not be calculated")
        }
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let cell = calendar.dequeueReusableCell(withReuseIdentifier: "calendarViewCell", for: indexPath) as? CalendarViewCell else {
            fatalError("Could not dequeue")
        }
        
        self.handleCellConfiguration(cell: cell, cellState: cellState, date: date)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(for: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.handleCellConfiguration(cell: cell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.handleCellConfiguration(cell: cell, cellState: cellState, date: date)
        
        self.selectedDate = date
    }
    
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState, date: Date) {
        guard let cell = cell as? CalendarViewCell else {
            return
        }
        
        self.handleCellConfiguration(cell: cell, cellState: cellState, date: date)
    }
    
    func handleCellConfiguration(cell: CalendarViewCell, cellState: CellState, date: Date) {
        cell.dateLabel.text = cellState.text
        cell.hasItems = self.calendarStore.containsItems(for: date)
        cell.setup(calendar: self.calendar, cellState: cellState, date: date)
    }
}
