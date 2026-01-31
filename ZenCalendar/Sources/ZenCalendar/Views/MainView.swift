import SwiftUI

struct MainView: View {
    @StateObject private var calendarLogic = CalendarLogic()
    @State private var showDatePicker = false
    
    // Layout Constants
    private let panelWidth: CGFloat = 320
    private let horizontalPadding: CGFloat = 24
    
    // Height Constants
    private let headerTopPadding: CGFloat = 20
    private let headerHeight: CGFloat = 24
    private let headerBottomPadding: CGFloat = 16
    
    private let weekdayHeight: CGFloat = 16
    private let weekdayBottomPadding: CGFloat = 12
    
    // Grid: Cell Width ≈ 38.8 (calculated from (320 - 48) / 7)
    // We'll use fixed cell height to match width approx or just use aspect ratio logic in calc
    private let gridSpacing: CGFloat = 12
    
    private let almanacTopPadding: CGFloat = 20
    // Almanac height is dynamic based on content? Let's fix it for stability or measure it once?
    // Based on code: Date(20) + YI/JI(40) + Spacing... approx 110-120.
    // Let's rely on sizing, but for window resize we need a target.
    // Let's try to keep it flexible but anchored.
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background
            GlassBackgroundView()
            
            VStack(spacing: 0) {
                // --- 1. Header Section (Fixed Height) ---
                HStack {
                    Button(action: {
                        withAnimation { calendarLogic.previousMonth() }
                    }) {
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
                    
                    Button(action: {
                        withAnimation { calendarLogic.nextMonth() }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    .buttonStyle(.plain)
                }
                .frame(height: headerHeight) // LOCK HEIGHT
                .padding(.horizontal, horizontalPadding)
                .padding(.top, headerTopPadding)
                .padding(.bottom, headerBottomPadding)
                
                // --- 2. Weekdays (Fixed Height) ---
                HStack {
                    ForEach(["周一", "周二", "周三", "周四", "周五", "周六", "周日"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: weekdayHeight) // LOCK HEIGHT
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, weekdayBottomPadding)
                
                // --- 3. Calendar Grid (Dynamic Height) ---
                CalendarGridView(calendarLogic: calendarLogic)
                    .padding(.horizontal, horizontalPadding)
                    .id(calendarLogic.currentMonth) // Trigger transition
                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                    
                // --- 4. Almanac (Bottom Anchor) ---
                AlmanacPanel(selectedDate: calendarLogic.selectedDate)
                    .padding(.top, almanacTopPadding)
                    .padding(.horizontal, 0)
                    .padding(.bottom, 0)
            }
            // Date Picker Overlay
            if showDatePicker {
                DatePickerOverlay(selectedDate: $calendarLogic.currentMonth, isPresented: $showDatePicker)
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
                    .zIndex(100)
            }
        }
        .frame(width: panelWidth, alignment: .top)
        .onAppear {
            updateWindowSize()
        }
        .onChange(of: calendarLogic.currentMonth) { _ in
            withAnimation(.easeOut(duration: 0.2)) {
                updateWindowSize()
            }
        }
    }
    
    private func updateWindowSize() {
        // Calculate expected height
        let weeks = CGFloat(calendarLogic.numberOfWeeks)
        // Cell Width = (Width - Padding) / 7
        let cellWidth = (panelWidth - (horizontalPadding * 2)) / 7
        // Cell matches Width (AspectRatio 1)
        let cellHeight = cellWidth
        
        let gridHeight = (weeks * cellHeight) + ((weeks - 1) * 12) // 12 is grid spacing in CalendarGridView
        
        // Almanac Height estimation
        // Reduced from 160 to 128 to remove empty space
        let almanacEstHeight: CGFloat = 128 
        
        let total = headerTopPadding + headerHeight + headerBottomPadding +
                    weekdayHeight + weekdayBottomPadding +
                    gridHeight +
                    almanacTopPadding + almanacEstHeight
                    
        // Send to manager
        PanelManager.shared.updateHeight(total)
    }
    
    private func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 MMMM"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}
