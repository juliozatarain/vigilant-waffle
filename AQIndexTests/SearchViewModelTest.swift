//
//  AQIndexTests.swift
//  AQIndexTests
//
//  Created by Julio Zatarain on 6/25/24.
//

import XCTest
@testable import AQIndex

final class SearchViewModelTest: XCTestCase {
    var sut: SummaryScreenViewModel?
    var repositoryMock = MockRepository()
    var locationProviderMock = MockLocationProvider()

    override func setUp() async throws {
        sut = SummaryScreenViewModel(repository: repositoryMock, locationProvider: locationProviderMock)
    }

    func test_onViewDidAppear_location_authorization_denied_successful_call() async {
        DateHelper.dateFormatter.dateStyle = .short
        let expected = SummaryViewModel(locationInfo: LocationInfoViewModel(station: "name", lat: "23.0", long: "24.0"),
                                                              daySummary: [DaySummaryViewModel(pm25: "10.0", date: DateHelper.stringFromDate(date: DateHelper.yesterday ?? Date()), styling: .good),
                                                                           DaySummaryViewModel(pm25: "20.0", date: DateHelper.stringFromDate(date: DateHelper.today), styling: .moderate),
                                                                           DaySummaryViewModel(pm25: "30.0", date:DateHelper.stringFromDate(date: DateHelper.tomorrow ?? Date()), styling: .moderate)])
        
        
        // Given: screen has appeared
        // When: user is asked for location access authorization
        // And: the user denies the request
        locationProviderMock.authorizationStatus = .denied
        repositoryMock.presetResponse = repositoryMock.successFulResponse
        XCTAssertEqual(sut?.state, .loading)
        await sut?.onViewDidAppear()
        
        // And: the repository is called without lat/long info
        XCTAssertNil(repositoryMock.latProvided)
        XCTAssertNil(repositoryMock.longProvided)
        XCTAssertTrue(repositoryMock.getSummaryCalled)
        
        // Then: the view model should be updated with the fetched data
        XCTAssertEqual(sut?.state, .content(expected))
    }
    
    func test_onViewDidAppear_location_authorization_authorized_successful_call() async {
        DateHelper.dateFormatter.dateStyle = .short
        let expected = SummaryViewModel(locationInfo: LocationInfoViewModel(station: "name", lat: "23.0", long: "24.0"),
                                                              daySummary: [DaySummaryViewModel(pm25: "10.0", date: DateHelper.stringFromDate(date: DateHelper.yesterday ?? Date()), styling: .good),
                                                                           DaySummaryViewModel(pm25: "20.0", date: DateHelper.stringFromDate(date: DateHelper.today), styling: .moderate),
                                                                           DaySummaryViewModel(pm25: "30.0", date:DateHelper.stringFromDate(date: DateHelper.tomorrow ?? Date()), styling: .moderate)])
        // Given: screen has appeared
        // When: user is asked for location access authorization
        // And: the user grants the request
        locationProviderMock.authorizationStatus = .authorizedAlways
        locationProviderMock.locationResult = (lat: "5.0", long: "6.0")

        repositoryMock.presetResponse = repositoryMock.successFulResponse
        XCTAssertEqual(sut?.state, .loading)
        await sut?.onViewDidAppear()
        
        // And: the repository is called with correct lat/long info
        XCTAssertEqual(repositoryMock.latProvided, "5.0")
        XCTAssertEqual(repositoryMock.longProvided, "6.0")
        XCTAssertTrue(repositoryMock.getSummaryCalled)
        
        // Then: the view model should be updated with the fetched data
        XCTAssertEqual(sut?.state, .content(expected))
    }
}
