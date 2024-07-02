import Foundation
@testable import AQIndex

class MockAirQualityWebService: AirQualityWebServiceProtocol {
    var urlSession = URLSession.shared
    var presetData: Data?

    let successfulData = """
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
    

    func requestData(lat: String?, long: String?) async throws -> Data {
        if let presetData = presetData {
            return presetData
        } else {
            throw RemoteServiceError.failure
        }
    }
    
    func requestData(uid: String) async throws -> Data {
        if let presetData = presetData {
            return presetData
        } else {
            throw RemoteServiceError.failure
        }
    }
}

