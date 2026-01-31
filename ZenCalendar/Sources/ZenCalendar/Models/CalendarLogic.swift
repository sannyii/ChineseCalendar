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
    
    /// Generates the days to display in the grid - ALWAYS returns 42 days (6 weeks)
    func generateDaysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        // Always start from the first day of the first week
        let startDate = monthFirstWeek.start
        
        var days: [Date] = []
        // Always generate exactly 42 days (6 weeks)
        for i in 0..<42 {
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                days.append(date)
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
    
    /// Returns the number of weeks (rows) needed to display the current month
    var numberOfWeeks: Int {
        let days = generateDaysInMonth()
        return days.count / 7
    }
}
