import SwiftUI

struct AlmanacPanel: View {
    let selectedDate: Date
    
    private var lunarDate: LunarDate {
        LunarConverter.shared.lunarDate(from: selectedDate)
    }
    
    private var almanac: AlmanacData {
        LunarConverter.shared.getAlmanac(for: selectedDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // No divider - natural spacing only
            
            VStack(alignment: .leading, spacing: 4) {
                // Header: Solar Date & Lunar Year
                HStack(alignment: .lastTextBaseline) {
                    Text(formatSelectedDate())
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                    
                    Spacer()
                    
                    Text("\(lunarDate.year) 【\(lunarDate.zodiac)年】")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.primary.opacity(0.6))
                }
                
                // Subheader: Lunar Day
                HStack {
                    Text("\(lunarDate.month)\(lunarDate.day)")
                        .font(.system(size: 15))
                        .foregroundColor(.primary.opacity(0.8))
                    
                    if let festival = lunarDate.festival {
                        Text(festival)
                            .font(.system(size: 11, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(4)
                    } else if let term = lunarDate.solarTerm {
                        Text(term)
                            .font(.system(size: 11))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.primary.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            // Yi / Ji Section
            HStack(alignment: .top, spacing: 20) {
                // YI
                HStack(alignment: .top, spacing: 8) {
                    Text("宜")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Circle().fill(Color.green.opacity(0.7)))
                    
                    Text(almanac.yi.prefix(5).joined(separator: " "))
                        .font(.system(size: 13))
                        .foregroundColor(.primary.opacity(0.8))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // JI
                HStack(alignment: .top, spacing: 8) {
                    Text("忌")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Circle().fill(Color.red.opacity(0.7)))
                    
                    Text(almanac.ji.prefix(5).joined(separator: " "))
                        .font(.system(size: 13))
                        .foregroundColor(.primary.opacity(0.8))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        // Diagonal gradient background - very subtle, lighter than calendar
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.primary.opacity(0.01),
                    Color.blue.opacity(0.015),
                    Color.purple.opacity(0.01)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    private func formatSelectedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: selectedDate)
    }
}
