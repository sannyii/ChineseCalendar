import SwiftUI

struct CalendarGridView: View {
    @ObservedObject var calendarLogic: CalendarLogic
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(calendarLogic.generateDaysInMonth(), id: \.self) { date in
                DayCell(
                    date: date,
                    isSelected: calendarLogic.isSameDay(date1: date, date2: calendarLogic.selectedDate),
                    isCurrentMonth: calendarLogic.isSameMonth(date1: date, date2: calendarLogic.currentMonth),
                    isToday: Calendar.current.isDateInToday(date)
                )
                .onTapGesture {
                    calendarLogic.selectedDate = date
                }
            }
        }
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let isToday: Bool
    
    private let lunarDate: LunarDate
    
    init(date: Date, isSelected: Bool, isCurrentMonth: Bool, isToday: Bool) {
        self.date = date
        self.isSelected = isSelected
        self.isCurrentMonth = isCurrentMonth
        self.isToday = isToday
        self.lunarDate = LunarConverter.shared.lunarDate(from: date)
    }
    
    var body: some View {
        ZStack {
            // Selection background - Strict Square with rounded corners
            if isSelected {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.8))
                    .aspectRatio(1, contentMode: .fit) // Force Square
            }
            
            ZStack {
                // Content (Number + Lunar) - Centered
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Solar Day - Standard macOS size (15pt)
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.system(size: 15, weight: (isSelected || isToday) ? .semibold : .regular))
                        .foregroundColor(textColor)
                        .frame(height: 18) // Fixed height anchor
                    
                    // PRIORITY: Festival > Solar Term > Lunar Day
                    if let festival = lunarDate.festival {
                        Text(festival)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(isSelected ? .white.opacity(0.9) : .red.opacity(0.9))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    } else if let term = lunarDate.solarTerm {
                        Text(term)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(isSelected ? .white.opacity(0.9) : .red.opacity(0.8))
                    } else {
                        Text(lunarDate.day)
                            .font(.system(size: 9))
                            .foregroundColor(lunarTextColor)
                    }
                    
                    Spacer()
                }
                .aspectRatio(1, contentMode: .fit)
                
                // Badges Layer - Independent positioning
                VStack {
                    HStack(alignment: .top) {
                        if let holiday = lunarDate.legalHoliday {
                            if !holiday.work {
                                // Rest Badge (休)
                                Text("休")
                                    .font(.system(size: 7, weight: .bold))
                                    .foregroundColor(isSelected ? .white : .red)
                                    .padding(.leading, 6)
                            }
                        }
                        Spacer()
                        if let holiday = lunarDate.legalHoliday {
                            if holiday.work {
                                // Work Badge (班)
                                Text("班")
                                    .font(.system(size: 7, weight: .bold))
                                    .foregroundColor(isSelected ? .white.opacity(0.9) : .gray)
                                    .padding(.trailing, 6)
                            }
                        }
                    }
                    .padding(.top, 10) // Approx 3px higher than the number text visual line (assuming centered selection)
                    Spacer()
                }
            }
            .aspectRatio(1, contentMode: .fit)        }
        // Remove fixed height, let the grid layout control it
        .frame(maxWidth: .infinity) 
        .contentShape(Rectangle())
    }
    
    private var textColor: Color {
        if isSelected { return .white }
        if !isCurrentMonth { return .secondary.opacity(0.3) }
        if isToday { return .blue } // Highlight Today with Blue
        
        return .primary.opacity(0.9)
    }
    
    private var lunarTextColor: Color {
        if isSelected { return .white.opacity(0.9) }
        if !isCurrentMonth { return .secondary.opacity(0.3) }
        if isToday { return .blue.opacity(0.8) } // Highligh Lunar Today slightly
        return .secondary.opacity(0.8)
    }
}
