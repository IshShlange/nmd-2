import Foundation

struct UnsplashSearchResponse: Codable {
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Codable, Identifiable {
    let id: String
    let likes: Int
    let urls: PhotoURLs
    let user: User
    let links: PhotoLinks
    
    struct PhotoURLs: Codable {
        let small: String
        let regular: String
    }
    
    struct User: Codable {
        let name: String
        let links: UserLinks
        
        struct UserLinks: Codable {
            let html: String
        }
    }
    
    struct PhotoLinks: Codable {
        let html: String
    }
}