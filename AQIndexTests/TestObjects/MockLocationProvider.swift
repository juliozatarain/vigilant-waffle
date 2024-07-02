import Foundation
import CoreLocation
@testable import AQIndex

class MockLocationProvider: LocationProviderProtocol {
    var authorizationStatus: CLAuthorizationStatus?
    var locationResult: (lat: String, long: String)?
    var shouldThrowError = false
    
    func requestLocationAuthorization() async -> CLAuthorizationStatus {
        return authorizationStatus ?? .notDetermined
    }
    
    func queryUserLocation() async throws -> (lat: String, long: String) {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: -1, userInfo: nil)
        }
        guard let result = locationResult else {
            throw NSError(domain: "MockError", code: -1, userInfo: nil)
        }
        return result
    }
}
