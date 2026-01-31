import Foundation
import SwiftUI
import LunarSwift

/// Represents a Lunar Date
struct LunarDate {
    let year: String
    let month: String
    let day: String
    let zodiac: String 
    let solarTerm: String?
    let festival: String? // e.g. 腊八节, 除夕, 春节
    let legalHoliday: Holiday? // Statutory holiday data (Work/Rest)
}

/// A model representing the "Yi" (Suitable) and "Ji" (Avoid) activities for a day.
struct AlmanacData {
    let yi: [String] // Suitable
    let ji: [String] // Avoid
}

class LunarConverter {
    static let shared = LunarConverter()
    
    func lunarDate(from date: Date) -> LunarDate {
        let lunar = Lunar.fromDate(date: date)
        
        // Year: e.g. 甲辰
        let yearGanZhi = lunar.yearInGanZhi
        
        // Zodiac: e.g. 龙
        let zodiac = lunar.yearShengXiao
        
        // Month: e.g. 正月 or 闰二月
        let monthStr = lunar.monthInChinese + "月"
        // The library might return "正", "二". We add "月".
        // Actually typical output is "正月".
        
        // Day: e.g. 初一
        let dayStr = lunar.dayInChinese
        
        // Solar Term (Jieqi): e.g. 立春. Returns empty string if none.
        let jieQi = lunar.jieQi
        let solarTerm = jieQi.isEmpty ? nil : jieQi
        
        // Festivals: e.g. 腊八节. The library returns [String]
        let festivals = lunar.festivals
        let festival = festivals.first // Grab the first one (primary)
        
        // Statutory Holiday
        let calendar = Calendar.current
        let y = calendar.component(.year, from: date)
        let m = calendar.component(.month, from: date)
        let d = calendar.component(.day, from: date)
        let legalHoliday = HolidayUtil.getHolidayByYmd(year: y, month: m, day: d)
        
        return LunarDate(
            year: yearGanZhi,
            month: monthStr,
            day: dayStr,
            zodiac: zodiac,
            solarTerm: solarTerm,
            festival: festival,
            legalHoliday: legalHoliday
        )
    }
    
    func getAlmanac(for date: Date) -> AlmanacData {
        let lunar = Lunar.fromDate(date: date)
        
        // The library returns lists of strings directly
        let yi = lunar.dayYi
        let ji = lunar.dayJi
        
        return AlmanacData(yi: yi, ji: ji)
    }
}
