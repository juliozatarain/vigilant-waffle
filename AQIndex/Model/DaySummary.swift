import Foundation

struct StationDaySummary: Equatable {
    let daySummary: [DaySummary]
    let stationInfo: CityInfo
}

struct DaySummary: Equatable, Decodable {
    let date: Date
    let index: Double
}

struct PM25Data: Decodable {
    let avg: Double
    let day: String
    let max: Int
    let min: Int
}

struct AirQualityData: Decodable {
    let pm25: [PM25Data]
}

struct ForecastData: Decodable {
    let forecast: DailyData
    let city: CityInfo
}

struct CityInfo: Equatable, Decodable {
    let geo: [Double]
    let name: String
}
struct DailyData: Decodable {
    let daily: AirQualityData
}

struct AirQualityResponse: Decodable {
    let status: String
    let data: ForecastData
}
