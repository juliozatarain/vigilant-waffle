import Foundation

protocol RemoteService {
    var urlSession: URLSession { get }
    func requestData(for request: URLRequest) async throws -> Data
}

extension RemoteService {
    func requestData(for request: URLRequest) async throws -> Data {
        let response = try await urlSession.data(for: request)
        if (response.1 as? HTTPURLResponse)?.statusCode != 200 {
            throw RemoteServiceError.failure
        }
        return response.0
    }
}



