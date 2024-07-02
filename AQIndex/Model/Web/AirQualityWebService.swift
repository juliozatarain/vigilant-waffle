import Foundation

protocol AirQualityWebServiceProtocol: RemoteService {
    func requestData(lat: String?, long: String?) async throws -> Data
    func requestData(uid: String) async throws -> Data
}

final class AirQualityWebService: AirQualityWebServiceProtocol {
    struct RoutingInformation {
        static let baseUrl = "https://api.waqi.info/feed/"
        static let method = "GET"
        static let tokenQueryParamName = "token"
        static let tokenQueryParamValue = "86eecd7b5c8f75e202981f8700da49b7627e598e"
    }

    let urlSession = URLSession.shared
    
    func requestData(lat: String?=nil, long: String?=nil) async throws -> Data {
        var lastPathComponent = "here"
        if let lat = lat, let long = long {
            lastPathComponent = "geo:\(lat);\(long)"
        }
        let queryParams = [RoutingInformation.tokenQueryParamName: RoutingInformation.tokenQueryParamValue]
        guard let url = createURL(baseURL: RoutingInformation.baseUrl,  lastPathComponent: lastPathComponent, queryParams: queryParams) else { throw RemoteServiceError.invalidURL
        }
        let request = createRequest(url: url)
        return try await requestData(for: request)
    }
    
    func requestData(uid: String) async throws -> Data {
        let lastPathComponent = "@\(uid)"
        let queryParams = [RoutingInformation.tokenQueryParamName: RoutingInformation.tokenQueryParamValue]
        guard let url = createURL(baseURL: RoutingInformation.baseUrl,  lastPathComponent: lastPathComponent, queryParams: queryParams) else { throw RemoteServiceError.invalidURL
        }
        let request = createRequest(url: url)
        return try await requestData(for: request)
    }
    
    func createURL(baseURL: String, lastPathComponent: String?, queryParams: [String: String]) -> URL? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        if let lastPathComponent = lastPathComponent {
            urlComponents.path = (urlComponents.path as NSString).appendingPathComponent(lastPathComponent)
        }
        let queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    private func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = RoutingInformation.method
        return request
    }
}




