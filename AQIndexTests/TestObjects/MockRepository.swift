//
//  RepositoryMock.swift
//  AQIndexTests
//
//  Created by Julio Zatarain on 6/25/24.
//

import Foundation
import UIKit
@testable import AQIndex

final class MockRepository: AirQualityRepositoryProtocol {

    var latProvided: String? = nil
    var longProvided: String? = nil
    var successFulResponse = StationDaySummary(daySummary: [DaySummary(date: MockRepository.removeTimeStamp(providedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())), index: 10),
                                                            DaySummary(date: MockRepository.removeTimeStamp(providedDate: Date()), index: 20),
                                                            DaySummary(date: MockRepository.removeTimeStamp(providedDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())), index: 30)], stationInfo: CityInfo(geo: [23.0, 24.0], name: "name"))
    var getSummaryCalled = false
    
    var presetResponse = AQIndex.StationDaySummary(daySummary: [], stationInfo: CityInfo(geo: [], name: ""))
    
   
    
    func getAirQualityData(lat: String?, long: String?) async throws -> AQIndex.StationDaySummary {
        latProvided = lat
        longProvided = long
        getSummaryCalled = true
        return presetResponse
    }
    
    func getAirQualityData(uid: String) async throws -> AQIndex.StationDaySummary {
        return presetResponse
    }
    
    static func removeTimeStamp(providedDate: Date?) -> Date {
        guard let fromDate = providedDate else { return Date() }
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            return Date()
        }
        return date
    }
}
