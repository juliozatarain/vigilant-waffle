import Foundation

final class DateHelper {
    
    static var dateFormatter: DateFormatter = DateFormatter()
    
    static var calendar: Calendar {
        return Calendar.current

    }
    
    static var todayString: String? {
        return stringDateWithOffsetFromToday(dayOffset: 0)
    }
    
    static var today: Date {
        return Date()
    }
    
    static var tomorrowString: String? {
        return stringDateWithOffsetFromToday(dayOffset: 1)
    }
    
    static var tomorrow: Date? {
        return dateWithOffsetFromToday(dayOffset: 1)
    }
    
    static var yesterdayString: String? {
        return stringDateWithOffsetFromToday(dayOffset: -1)
    }
    
    static var yesterday: Date? {
        return dateWithOffsetFromToday(dayOffset: -1)
    }
    
    static func stringDateWithOffsetFromToday(dayOffset: Int) -> String? {
        guard let date = dateWithOffsetFromToday(dayOffset: dayOffset) else { return nil}
        return dateFormatter.string(from: date)
    }
    
    static func dateWithOffsetFromToday(dayOffset: Int) -> Date? {
        let today = Date()
        return calendar.date(byAdding: .day, value: dayOffset, to: today)
    }
    
    static func stringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}

