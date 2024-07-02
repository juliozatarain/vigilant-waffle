
import Foundation
import UIKit

enum AirQualitySeverityStyling: Equatable {
    case good, moderate, unhealthySensitive, unhealthy, veryUnhealthy, hazardous
    
    var backgroundColor: UIColor {
        switch self {
        case .good:
            return UIColor(red: 99/255.0, green: 107/255.0, blue: 47/255.0, alpha: 1.0)
        case .moderate:
            return UIColor(red: 1, green: 0.702, blue: 0.263, alpha: 1)
        case .unhealthySensitive:
            return UIColor(red: 255/255.0, green: 191/255.0, blue: 0/255.0, alpha: 1.0)    
        case .unhealthy:
            return UIColor(red: 102/255.0, green: 0/255.0, blue: 51/255.0, alpha: 1.0)
        case .veryUnhealthy:
            return UIColor(red: 0.616, green: 0, blue: 1, alpha: 1)
        case .hazardous:
            return UIColor(red: 0.537, green: 0.318, blue: 0.161, alpha: 1)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .good, .moderate, .unhealthySensitive, .unhealthy, .veryUnhealthy, .hazardous:
            return UIColor.black
        }
    }
    
    var iconName: String {
        switch self {
        case .good:
            return "sun.max.fill"
        case .moderate:
            return "cloud.sun.fill"
        case .unhealthySensitive:
            return "cloud.sun.rain.fill"
        case .unhealthy:
            return "cloud.bolt.fill"
        case .veryUnhealthy:
            return "smoke.fill"
        case .hazardous:
            return "exclamationmark.triangle"
        }
    }
}

func getAirQualitySeverityStyling(aqiValue: Double) -> AirQualitySeverityStyling {
    switch aqiValue {
    case 0...12:
        return .good
    case 12.1...35.4:
        return .moderate
    case 35.5...55.4:
        return .unhealthySensitive
    case 55.5...150.4:
        return .unhealthy
    case 150.5...250.4:
        return .veryUnhealthy
    default:
        return .hazardous
    }
}
