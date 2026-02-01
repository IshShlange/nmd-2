import Foundation

class UnsplashAPIService {
    private let accessKey = "nljBs6Ggdpc4xaMfCavE90Z0s_Hw1wESy7B5zEg90No" 
    private let baseURL = "https://api.unsplash.com/search/photos"
    
    func searchPhotos(query: String, page: Int = 1, perPage: Int = 20) async throws -> [UnsplashPhoto] {
        guard !query.isEmpty else { return [] }
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(UnsplashSearchResponse.self, from: data)
        return decoded.results
    }
}