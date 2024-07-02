import Foundation
import UIKit

class SummaryScreenViewModel {
    let repository: AirQualityRepositoryProtocol
    let locationProvider: LocationProviderProtocol
    let formatter: DateFormatter
    
    var state: SummaryViewState = .loading
    var onStateChange: ((SummaryViewState) -> Void)?
        
    init(repository: AirQualityRepositoryProtocol = AirQualityRepository(), 
         locationProvider: LocationProviderProtocol = LocationProvider()) {
        self.repository = repository
        self.locationProvider = locationProvider
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .short
        self.formatter = dateFormatter
    }
    
    func onViewDidAppear() async {
        let result: SummaryViewState
        do {
            let authorizationStatus = await locationProvider.requestLocationAuthorization()
            switch authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                let location = try await locationProvider.queryUserLocation()
                result = try await map(self.repository.getAirQualityData(lat: location.lat, long: location.long))
                await MainActor.run {
                    onStateChange?(state)
                }
            default:
                result = try await map(self.repository.getAirQualityData())
            }
        } catch {
            result = .noContent("Error")
        }
        state = result
        await MainActor.run {
            onStateChange?(state)
        }
    }
    
    func onSearchItemWasSelected(uid: String) async {
        let result: SummaryViewState
        do {
            result = try await map(self.repository.getAirQualityData(uid: uid))
            await MainActor.run {
                onStateChange?(state)
            }
        } catch {
            result = .noContent("Error")
        }
        state = result
        await MainActor.run {
            onStateChange?(state)
        }
    }
    
    func locationButtonWasTapped() async {
        await onViewDidAppear()
    }
    
    private func map(_ summary: StationDaySummary) -> SummaryViewState {
        guard summary.daySummary.count > 0 else { return .noContent("No Content") }
        let daySummary = getFilteredAndSortedObjects(days: summary.daySummary).map{ map($0) }
        return .content(SummaryViewModel(locationInfo: map(stationInfo: summary.stationInfo), daySummary: daySummary))
    }
    
    func getFilteredAndSortedObjects(days: [DaySummary]) -> [DaySummary] {
        let calendar = Calendar.current
        let yesterday = calendar.startOfDay(for: Date().addingTimeInterval(-86400))
        let filteredObjects = days.filter { $0.date >= yesterday }
        let sortedObjects = filteredObjects.sorted { $0.date < $1.date }
        let firstThreeObjects = Array(sortedObjects.prefix(3))
        return firstThreeObjects
    }
    
    private func map(stationInfo: CityInfo) -> LocationInfoViewModel {
        return LocationInfoViewModel(station: stationInfo.name, lat: String(stationInfo.geo.first ?? 0), long: String(stationInfo.geo.last ?? 0))
    }
    
    private func map(_ date: Date) -> String {
        return formatter.string(from: date)
    }
    
    private func map(_ day: DaySummary) -> DaySummaryViewModel {
        return DaySummaryViewModel(pm25: String(day.index), date: map(day.date), styling: determineStyling(index: day.index))
    }
    
    private func determineStyling(index: Double) -> AirQualitySeverityStyling {
        switch index {
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
}

struct SummaryViewModel: Equatable {
    var locationInfo: LocationInfoViewModel
    var daySummary: [DaySummaryViewModel]
}

struct DaySummaryViewModel: Equatable {
    let pm25: String
    let date: String
    let styling: AirQualitySeverityStyling
}

struct LocationInfoViewModel: Equatable {
    let station: String
    let lat: String?
    let long: String?
}

enum SummaryViewState: Equatable {
    case noContent(String)
    case content(SummaryViewModel)
    case loading
}
