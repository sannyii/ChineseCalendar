import SwiftUI

struct MainView: View {
    @StateObject private var calendarLogic = CalendarLogic()
    @State private var showDatePicker = false
    
    var body: some View {
        ZStack {
            // Background
            GlassBackgroundView()
            
            VStack(spacing: 0) {
                // Top Bar: Navigation
                // Top Bar: Navigation
                // Top Bar: Navigation
                HStack {
                    Button(action: { calendarLogic.previousMonth() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    // Header Clickable -> Date Picker
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showDatePicker.toggle()
                        }
                    }) {
                        Text(monthTitle(for: calendarLogic.currentMonth))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(.primary.opacity(0.9))
                            .contentShape(Rectangle()) // Make clicking easier
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
                .padding(.top, 20)
                .padding(.bottom, 16)
                // Ensure zIndex is lower than overlay if needed, but overlay is topmost in ZStack
                
                // ... rest of VStack ...
                
                // Weekday Headers (Monday first)
                HStack {
                    ForEach(["周一", "周二", "周三", "周四", "周五", "周六", "周日"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 4)
                
                
                // Calendar Grid
                CalendarGridView(calendarLogic: calendarLogic)
                    .padding(.horizontal, 24)
                
                // Almanac / Today Info
                AlmanacPanel(selectedDate: calendarLogic.selectedDate)
                    .padding(.horizontal, 0) // Full width at bottom style
                    .padding(.bottom, 0)
            }
            
            // Date Picker Overlay
            if showDatePicker {
                DatePickerOverlay(selectedDate: $calendarLogic.currentMonth, isPresented: $showDatePicker)
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
                    .zIndex(100) // Ensure it's on top
            }
        }
        // Force top alignment to prevent vertical jumping
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        // Measure content size
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: HeightPreferenceKey.self, value: geo.size.height)
            }
        )
        .onPreferenceChange(HeightPreferenceKey.self) { height in
            DispatchQueue.main.async {
                PanelManager.shared.updateHeight(height)
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

// Preference Key for passing height up
struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
