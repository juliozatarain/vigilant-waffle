import Foundation

struct SearchResponse: Codable {
    let status: String
    let data: [StationData]
    
    struct StationData: Codable {
        let uid: Int
        let aqi: String
        let station: Station
        
        struct Station: Codable {
            let name: String
            let geo: [Double]
        }
    }
}
