import Foundation

struct UserProfile: Codable {
    var name: String
    var email: String
    var age: Int
    
    init(name: String = "", email: String = "", age: Int = 0) {
        self.name = name
        self.email = email
        self.age = age
    }
}