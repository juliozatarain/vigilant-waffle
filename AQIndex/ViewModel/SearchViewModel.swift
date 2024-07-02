import Foundation

class SearchResultViewModel {
    
    var onSearchResultsUpdated: (([SearchResultItemViewModel]) -> Void)?
    
    let repository: SearchRepositoryProtocol
    
    init(repository: SearchRepository = SearchRepository()) {
        self.repository = repository
    }
    
    func searchQueryDidChange(query: String) {
        Task.detached {
           let results = try await self.repository.searchStation(keyword: query)
            await MainActor.run {
                self.onSearchResultsUpdated?(results)
            }
        }
    }
}


struct SearchResultItemViewModel {
    let name: String
    let uid: String
}
