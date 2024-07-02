import Foundation
import CoreLocation

enum LocationResult {
    case unavailable
    case acquired(Double, Double)
}

protocol LocationProviderProtocol {
    func requestLocationAuthorization() async -> CLAuthorizationStatus
    func queryUserLocation() async throws -> (lat: String, long: String)
}

final class LocationProvider: NSObject, LocationProviderProtocol, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<(lat: String, long: String), Error>?
    
    func requestLocationAuthorization() async -> CLAuthorizationStatus {
        if case locationManager.authorizationStatus = .notDetermined {
            locationManager.delegate = self
            return await withCheckedContinuation { continuation in
                self.authorizationContinuation = continuation
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            return locationManager.authorizationStatus
        }
    }
    
    func queryUserLocation() async throws -> (lat: String, long: String) {
        locationManager.delegate = self
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationContinuation?.resume(returning: status)
        authorizationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            locationContinuation?.resume(throwing: NSError(domain: "LocationError", code: -1, userInfo: nil))
            return
        }
        let lat = String(format: "%.6f", location.coordinate.latitude)
        let long = String(format: "%.6f", location.coordinate.longitude)
        locationContinuation?.resume(returning: (lat, long))
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}
