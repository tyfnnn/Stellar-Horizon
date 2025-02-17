import Foundation
import FirebaseFirestore

struct FirestoreUser: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var name: String
    var birthDate: Date
    var gender: Gender
    var occupation: Occupation
    var displayName: String?
    var profileImageURL: String?
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var lastUpdated: Date?
    
    enum Gender: String, Codable {
        case male = "male"
        case female = "female"
        case other = "other"
        case preferNotToSay = "prefer_not_to_say"
    }
    
    enum Occupation: String, Codable {
        case student = "student"
        case employed = "employed"
        case selfEmployed = "self_employed"
        case other = "other"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case birthDate = "birth_date"
        case gender
        case occupation
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
            "occupation": occupation.rawValue,
            "display_name": displayName ?? NSNull(),
            "profile_image_url": profileImageURL ?? NSNull(),
            "created_at": FieldValue.serverTimestamp(),
            "last_updated": FieldValue.serverTimestamp()
        ]
    }
}
