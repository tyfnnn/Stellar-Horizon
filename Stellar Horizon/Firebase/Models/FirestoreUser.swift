import Foundation
import FirebaseFirestore

struct FirestoreUser: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var name: String
    var birthDate: Date
    var gender: Gender
    var displayName: String?
    var profileImageURL: String?
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var lastUpdated: Date?
    
    enum Gender: String, Codable, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
        case preferNotToSay = "Prefer not to say"
        
        var display: String {
            switch self {
            case .male: return "Male"
            case .female: return "Female"
            case .other: return "Other"
            case .preferNotToSay: return "Prefer not to say"
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case birthDate = "birth_date"
        case gender
        case displayName = "display_name"
        case profileImageURL = "profile_image_url"
        case createdAt = "created_at"
        case lastUpdated = "last_updated"
    }
    
    var dictionary: [String: Any] {
        return [
            "email": email,
            "name": name,
            "birth_date": birthDate,
            "gender": gender.rawValue,
            "display_name": displayName ?? NSNull(),
            "profile_image_url": profileImageURL ?? NSNull(),
            "created_at": FieldValue.serverTimestamp(),
            "last_updated": FieldValue.serverTimestamp()
        ]
    }
    
    func getSerializableDictionary() -> [String: Any] {
        return [
            "email": email,
            "name": name,
            "birth_date": birthDate,
            "gender": gender.rawValue,
            "display_name": displayName as Any,
            "profile_image_url": profileImageURL as Any,
            "created_at": FieldValue.serverTimestamp(),
            "last_updated": FieldValue.serverTimestamp()
        ]
    }
}
