import Foundation

protocol FriendsServiceProtocol {
    func fetchFriends() async throws -> [Friend]
    func addFriend(_ friend: Friend) async throws -> Friend
    func updateFriend(_ friend: Friend) async throws -> Friend
    func deleteFriend(_ id: UUID) async throws
    func generateRandomFriends(count: Int) async throws -> [Friend]
}

class FriendsService: FriendsServiceProtocol {
    private var friends: [Friend] = Friend.sampleData
    
    func fetchFriends() async throws -> [Friend] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return friends
    }
    
    func addFriend(_ friend: Friend) async throws -> Friend {
        try await Task.sleep(nanoseconds: 500_000_000)
        let newFriend = friend
        friends.append(newFriend)
        return newFriend
    }
    
    func updateFriend(_ friend: Friend) async throws -> Friend {
        try await Task.sleep(nanoseconds: 500_000_000)
        guard let index = friends.firstIndex(where: { $0.id == friend.id }) else {
            throw NSError(domain: "FriendNotFound", code: 404)
        }
        friends[index] = friend
        return friend
    }
    
    func deleteFriend(_ id: UUID) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        friends.removeAll { $0.id == id }
    }
    
    func generateRandomFriends(count: Int) async throws -> [Friend] {
        let url = URL(string: "https://randomuser.me/api/?results=\(count)&inc=name,email,phone,picture,location,dob")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(RandomUserResult.self, from: data)
        
        let newFriends = result.results.map { user -> Friend in
            let name = "\(user.name.first) \(user.name.last)"
            let address = "\(user.location.street.number) \(user.location.street.name), \(user.location.city)"
            let birthday = ISO8601DateFormatter().date(from: user.dob.date)
            
            return Friend(
                name: name,
                email: user.email,
                phone: user.phone,
                avatar: user.picture.large,
                tags: ["Random"],
                address: address,
                birthday: birthday
            )
        }
        
        friends.append(contentsOf: newFriends)
        return newFriends
    }
    
    private struct RandomUserResult: Codable {
        let results: [RandomUser]
    }
    
    private struct RandomUser: Codable {
        let name: Name
        let email: String
        let phone: String
        let picture: Picture
        let location: Location
        let dob: Dob
        
        struct Name: Codable {
            let first: String
            let last: String
        }
        
        struct Picture: Codable {
            let large: String
        }
        
        struct Location: Codable {
            let street: Street
            let city: String
            
            struct Street: Codable {
                let number: Int
                let name: String
            }
        }
        
        struct Dob: Codable {
            let date: String
        }
    }
}
