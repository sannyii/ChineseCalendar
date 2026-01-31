import SwiftUI

struct MainView: View {
    @StateObject private var calendarLogic = CalendarLogic()
    @State private var showDatePicker = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background
            GlassBackgroundView()
            
            VStack(spacing: 0) {
                // --- 1. Header Section ---
                HStack {
                    Button(action: { calendarLogic.previousMonth() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showDatePicker.toggle()
                        }
                    }) {
                        Text(monthTitle(for: calendarLogic.currentMonth))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(.primary.opacity(0.9))
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button(action: { calendarLogic.nextMonth() }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.top, 36)
                .padding(.bottom, 16)
                
                // --- 2. Weekdays ---
                HStack {
                    ForEach(["周一", "周二", "周三", "周四", "周五", "周六", "周日"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
                
                // --- 3. Calendar Grid ---
                CalendarGridView(calendarLogic: calendarLogic)
                    .padding(.horizontal, 24)
                
                Spacer(minLength: 16)
                
                // --- 4. Almanac at Bottom ---
                AlmanacPanel(selectedDate: calendarLogic.selectedDate)
            }
            
            // Date Picker Overlay
            if showDatePicker {
                DatePickerOverlay(selectedDate: $calendarLogic.currentMonth, isPresented: $showDatePicker)
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
                    .zIndex(100)
            }
        }
    }
    
    private func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 MMMM"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}
