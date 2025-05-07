import Foundation

class FriendsViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var searchText = ""
    @Published var selectedTag: String?
    @Published var showingAddFriend = false
    @Published var showingRandomFriendsSheet = false
    
    private let friendsService: FriendsServiceProtocol
    
    init(friendsService: FriendsServiceProtocol = FriendsService()) {
        self.friendsService = friendsService
    }
    
    var filteredFriends: [Friend] {
        let filteredBySearch = friends.filter { friend in
            searchText.isEmpty ||
            friend.name.localizedCaseInsensitiveContains(searchText) ||
            friend.email.localizedCaseInsensitiveContains(searchText)
        }
        
        if let selectedTag = selectedTag {
            return filteredBySearch.filter { $0.tags.contains(selectedTag) }
        }
        
        return filteredBySearch
    }
    
    var favoriteFriends: [Friend] {
        friends.filter { $0.favorite }
    }
    
    var allTags: [String] {
        Array(Set(friends.flatMap { $0.tags })).sorted()
    }
    
    @MainActor
    func fetchFriends() async {
        isLoading = true
        error = nil
        
        do {
            friends = try await friendsService.fetchFriends()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    @MainActor
    func addFriend(_ friend: Friend) async {
        do {
            let newFriend = try await friendsService.addFriend(friend)
            friends.append(newFriend)
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func updateFriend(_ friend: Friend) async {
        do {
            let updatedFriend = try await friendsService.updateFriend(friend)
            if let index = friends.firstIndex(where: { $0.id == updatedFriend.id }) {
                friends[index] = updatedFriend
            }
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func deleteFriend(at offsets: IndexSet) {
        offsets.forEach { index in
            let friend = friends[index]
            Task {
                do {
                    try await friendsService.deleteFriend(friend.id)
                    await fetchFriends()
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    @MainActor
    func toggleFavorite(for friend: Friend) {
        if let index = friends.firstIndex(where: { $0.id == friend.id }) {
            friends[index].favorite.toggle()
        }
    }
    
    @MainActor
    func generateRandomFriends(count: Int) async {
        do {
            let newFriends = try await friendsService.generateRandomFriends(count: count)
            friends.append(contentsOf: newFriends)
        } catch {
            self.error = error
        }
    }
}
