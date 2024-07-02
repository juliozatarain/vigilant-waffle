import Foundation

enum RemoteServiceError: Error {
    case invalidURL
    case failure
}

enum RemoteServiceDecodingError: Error {
    case decodingFailed
}
