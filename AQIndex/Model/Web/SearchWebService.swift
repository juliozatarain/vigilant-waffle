import Foundation

protocol SearchWebServiceProtocol: RemoteService {
    func requestSearchData(keyword: String) async throws -> Data
}

final class SearchWebService: SearchWebServiceProtocol {
    struct RoutingInformation {
        static let baseUrl = "https://api.waqi.info/search/"
        static let method = "GET"
        static let tokenQueryParamName = "token"
        static let tokenQueryParamValue = "demo"
        static let keywordQueryParamName = "keyword"
    }

    let urlSession = URLSession.shared
    
    func requestSearchData(keyword: String) async throws -> Data {
        let queryParams = [
            RoutingInformation.tokenQueryParamName: RoutingInformation.tokenQueryParamValue,
            RoutingInformation.keywordQueryParamName: keyword
        ]
        guard let url = createURL(baseURL: RoutingInformation.baseUrl, queryParams: queryParams) else {
            throw RemoteServiceError.invalidURL
        }
        let request = createRequest(url: url)
        return try await requestData(for: request)
    }
    
    private func createURL(baseURL: String, queryParams: [String: String]) -> URL? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
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
