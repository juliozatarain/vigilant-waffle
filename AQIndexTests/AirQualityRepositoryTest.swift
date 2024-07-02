//
//  RepositoryTest.swift
//  AQIndexTests
//
//  Created by Julio Zatarain on 6/26/24.
//

import XCTest
@testable import AQIndex

final class AirQualityRepositoryTest: XCTestCase {
    var sut: AirQualityRepository?
    var mockService = MockAirQualityWebService()
    var successfulData: Data?
    var expectedObject =  StationDaySummary(daySummary:[DaySummary(date: MockRepository.removeTimeStamp(providedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()), index: 56.0),
                                                        DaySummary(date: MockRepository.removeTimeStamp(providedDate: Date()), index: 50.0),
                                                         DaySummary(date: MockRepository.removeTimeStamp(providedDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())), index: 43.0)],
                                            stationInfo: CityInfo(geo: [19.28,-99.68], name: "Oxto"))
  var getSummaryCalled = false

    override func setUp() async throws {
        DateHelper.dateFormatter.dateFormat = "yyyy/MM/dd"
        mockService = MockAirQualityWebService()
        sut = AirQualityRepository(service: mockService)
        successfulData = """
    {
      "status": "ok",
      "data": {
        "city": {
          "geo": [
            19.28,
            -99.68
          ],
          "name": "Oxto",
          "url": "https://aqicn.org/city/mexico/toluca/oxtotitlan",
          "location": ""
        },
        "forecast": {
          "daily": {
            "pm25": [
              {
                "avg": 56,
                "day": "\(DateHelper.yesterdayString ?? "")",
                "max": 105,
                "min": 19
              },
              {
                "avg": 50,
                "day": "\(DateHelper.todayString ?? "")",
                "max": 82,
                "min": 13
              },
              {
                "avg": 43,
                "day": "\(DateHelper.tomorrowString ?? "")",
                "max": 75,
                "min": 23
              }
            ]
          }
        }
      }
    }
    """.data(using: .utf8)
    }
    
    func test_onViewDidAppear_default_location_successful_response() async throws {
        // Given: that there is no lat long information available
        // When: the repository is called to fetch the air quality feed
        // And: The call is successful
        // Then: The repository should return decoded models
        mockService.presetData = mockService.successfulData
        let result = try await sut?.getAirQualityData()
        XCTAssertEqual(result, expectedObject)
    }
    
    func test_onViewDidAppear_default_location_service_error() async throws {
        // Given: that there is no lat long information available
        // When: the repository is called to fetch the air quality feed
        // And: The call results in a service error being thrown
        // Then: The repository should throw the same error
        mockService.presetData = nil
        do {
            let _ = try await sut?.getAirQualityData()
        } catch {
            XCTAssertEqual(error as? RemoteServiceError, RemoteServiceError.failure)
        }
    }
}
