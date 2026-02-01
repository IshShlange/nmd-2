import Foundation

@MainActor
class UnsplashSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var photos: [UnsplashPhoto] = []
    @Published var isLoading: Bool = false
    @Published var errorText: String? = nil
    
    private let apiService = UnsplashAPIService()
    
    func search() async {
        guard !query.isEmpty else {
            photos = []
            return
        }
        
        isLoading = true
        errorText = nil
        
        do {
            photos = try await apiService.searchPhotos(query: query)
        } catch {
            errorText = "Ошибка: \(error.localizedDescription)"
            photos = []
        }
        
        isLoading = false
    }
    
    func photographerURL(for photo: UnsplashPhoto) -> URL? {
        var urlString = photo.user.links.html
        urlString += "?utm_source=Assignment7App&utm_medium=referral"
        return URL(string: urlString)
    }
}