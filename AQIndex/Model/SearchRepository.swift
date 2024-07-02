//
//  SearchRepository.swift
//  AQIndex
//
//  Created by Julio Zatarain on 6/28/24.
//

import Foundation

protocol SearchRepositoryProtocol {
    func searchStation(keyword: String) async throws -> [SearchResultItemViewModel]
}

class SearchRepository: SearchRepositoryProtocol {
    let service: SearchWebServiceProtocol

    init(service: SearchWebServiceProtocol = SearchWebService()) {
        self.service = service
    }

    func searchStation(keyword: String) async throws -> [SearchResultItemViewModel] {
        do {
            let data = try await service.requestSearchData(keyword: keyword)
            return try map(data)
        } catch {
            throw error
        }
    }
    
    private func map(_ data: Data) throws -> [SearchResultItemViewModel] {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(SearchResponse.self, from: data)
            return response.data.map { SearchResultItemViewModel(name: $0.station.name, uid: String($0.uid)) }
        } catch {
            throw RemoteServiceDecodingError.decodingFailed
        }
    }
}
