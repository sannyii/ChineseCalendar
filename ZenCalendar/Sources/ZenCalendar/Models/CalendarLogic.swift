import Foundation
import SwiftUI

class CalendarLogic: ObservableObject {
    @Published var currentMonth: Date
    @Published var selectedDate: Date
    
    private var calendar: Calendar
    
    init() {
        var cal = Calendar.current
        cal.firstWeekday = 2 // Monday as first day of week
        self.calendar = cal
        
        let now = Date()
        self.currentMonth = now
        self.selectedDate = now
    }
    
    func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    func goToToday() {
        let now = Date()
        currentMonth = now
        selectedDate = now
    }
    
    /// Generates the days to display in the grid (including padding for previous/next months)
    func generateDaysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1) else {
            return []
        }
        
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        
        var days: [Date] = []
        calendar.enumerateDates(startingAfter: dateInterval.start - 1, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) { date, _, stop in
            if let date = date {
                if date < dateInterval.end {
                    days.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return days
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func isSameMonth(date1: Date, date2: Date) -> Bool {
        calendar.isDate(date1, equalTo: date2, toGranularity: .month)
    }
}
