import SwiftUI

struct DatePickerOverlay: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    @State private var workingDate: Date
    
    private let months = [
        "一月", "二月", "三月", "四月", 
        "五月", "六月", "七月", "八月", 
        "九月", "十月", "十一月", "十二月"
    ]
    
    // Grid for months: 4 rows x 3 columns
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    
    init(selectedDate: Binding<Date>, isPresented: Binding<Bool>) {
        self._selectedDate = selectedDate
        self._isPresented = isPresented
        self._workingDate = State(initialValue: selectedDate.wrappedValue)
    }
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isPresented = false
                    }
                }
            
            // Picker Card
            VStack(spacing: 16) {
                // Year Selector
                HStack {
                    Button(action: { changeYear(by: -1) }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary.opacity(0.8))
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                    
                    Text(yearString(for: workingDate))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(width: 80) // Fixed width for stability
                    
                    Button(action: { changeYear(by: 1) }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary.opacity(0.8))
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 4)
                
                // Month Grid
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(0..<12, id: \.self) { index in
                        Button(action: {
                            selectMonth(index)
                        }) {
                            Text(months[index])
                                .font(.system(size: 14, weight: isSameMonth(index) ? .bold : .medium))
                                .foregroundColor(isSameMonth(index) ? .white : .primary.opacity(0.8))
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(isSameMonth(index) ? Color.blue : Color.primary.opacity(0.05))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
            .background(
                VisualEffectView(material: .popover, blendingMode: .withinWindow)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
            )
            .frame(width: 280) // Compact width
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    // Logic Helpers
    
    private func yearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
    
    private func changeYear(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .year, value: value, to: workingDate) {
            workingDate = newDate
        }
    }
    
    private func isSameMonth(_ monthIndex: Int) -> Bool {
        let currentMonth = Calendar.current.component(.month, from: workingDate) - 1 // 0-indexed check
        return currentMonth == monthIndex
    }
    
    private func selectMonth(_ monthIndex: Int) {
        // Set month and apply
        var components = Calendar.current.dateComponents([.year, .month, .day], from: workingDate)
        components.month = monthIndex + 1
        components.day = 1 // reset to 1st to avoid invalid dates (e.g. Feb 30)
        
        if let newDate = Calendar.current.date(from: components) {
            selectedDate = newDate
            withAnimation(.spring()) {
                isPresented = false
            }
        }
    }
}
