
import Foundation

struct Friend: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var email: String
    var phone: String
    var avatar: String
    var notes: String
    var favorite: Bool
    var tags: [String]
    var address: String
    var birthday: Date?
    
    init(id: UUID = UUID(),
         name: String,
         email: String,
         phone: String,
         avatar: String,
         notes: String = "",
         favorite: Bool = false,
         tags: [String] = [],
         address: String = "",
         birthday: Date? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.avatar = avatar
        self.notes = notes
        self.favorite = favorite
        self.tags = tags
        self.address = address
        self.birthday = birthday
    }
    
    var age: Int? {
        guard let birthday = birthday else { return nil }
        return Calendar.current.dateComponents([.year], from: birthday, to: Date()).year
    }
    
    var birthdayString: String {
        guard let birthday = birthday else { return "Not set" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: birthday)
    }
}

extension Friend {
    static let sampleData: [Friend] = [
        Friend(name: "Alex Johnson", email: "alex@example.com", phone: "555-0101",
               avatar: "https://randomuser.me/api/portraits/men/1.jpg",
               notes: "Met at the coding workshop", favorite: true,
               tags: ["Work", "Tech"], address: "123 Main St, New York"),
        
        Friend(name: "Maria Garcia", email: "maria@example.com", phone: "555-0102",
               avatar: "https://randomuser.me/api/portraits/women/1.jpg",
               notes: "College roommate", favorite: true,
               tags: ["School"], address: "456 Oak Ave, Boston"),
        
        Friend(name: "James Smith", email: "james@example.com", phone: "555-0103",
               avatar: "https://randomuser.me/api/portraits/men/2.jpg",
               notes: "Neighbor", tags: ["Neighborhood"],
               address: "789 Pine Rd, Chicago", birthday: Calendar.current.date(byAdding: .year, value: -30, to: Date()))
    ]
}
