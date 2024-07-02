import UIKit

protocol AirQualityRepositoryProtocol {
    func getAirQualityData(lat: String?, long: String?) async throws -> StationDaySummary
    func getAirQualityData(uid: String) async throws -> StationDaySummary
}

extension AirQualityRepositoryProtocol {
    func getAirQualityData() async throws -> StationDaySummary {
        return try await getAirQualityData(lat: nil, long: nil)
    }
}

class AirQualityRepository: AirQualityRepositoryProtocol {
    let service: AirQualityWebServiceProtocol

    init(service: AirQualityWebServiceProtocol = AirQualityWebService()) {
        self.service = service
    }

    func getAirQualityData(lat: String?=nil, long: String?=nil) async throws -> StationDaySummary {
        do {
            return try await map(service.requestData(lat: lat, long: long))
        } catch {
            throw error
        }
    }
    
    func getAirQualityData(uid: String) async throws -> StationDaySummary {
        do {
            return try await map(service.requestData(uid: uid))
        } catch {
            throw error
        }
    }
    
    private func map(_ data: Data) throws -> StationDaySummary {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            let response = try decoder.decode(AirQualityResponse.self, from: data)
            print(String(data: data, encoding: .utf8)!)
            let summaries = response.data.forecast.daily.pm25.compactMap { pm25Data -> DaySummary? in
                guard let date = dateFormatter.date(from: pm25Data.day) else { return nil }
                return DaySummary(date: date, index: pm25Data.avg)
            }
            return StationDaySummary(daySummary: summaries, stationInfo: response.data.city)
        } catch {
            throw RemoteServiceDecodingError.decodingFailed
        }
    }
}
