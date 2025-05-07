
import SwiftUI

struct FriendsListView: View {
    @StateObject var viewModel = FriendsViewModel()
    @State private var selectedTab: Tab = .all
    
    enum Tab { case all, favorites }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("View", selection: $selectedTab) {
                    Text("All").tag(Tab.all)
                    Text("Favorites").tag(Tab.favorites)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.gray.opacity(0.1))
                
                ZStack {
                    if viewModel.isLoading && viewModel.friends.isEmpty {
                        ProgressView()
                            .scaleEffect(1.5)
                    } else if currentFriends.isEmpty {
                        EmptyStateView(searchText: viewModel.searchText)
                    } else {
                        List {
                            ForEach(currentFriends) { friend in
                                if let index = viewModel.friends.firstIndex(where: { $0.id == friend.id }) {
                                    NavigationLink(
                                        destination: FriendDetailView(friend: $viewModel.friends[index])
                                    ) {
                                        FriendRowView(friend: viewModel.friends[index]) {
                                            viewModel.toggleFavorite(for: viewModel.friends[index])
                                        }
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            viewModel.deleteFriend(at: IndexSet([index]))
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .listRowBackground(Color.gray.opacity(0.1))
                                }
                            }

                        }
                        .listStyle(.plain)
                    }
                }
                .searchable(text: $viewModel.searchText, prompt: "Search friends")
            }
            .navigationTitle("My Friends")
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        viewModel.showingAddFriend = true
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }
                    
                    Menu {
                        Button {
                            viewModel.showingRandomFriendsSheet = true
                        } label: {
                            Label("Generate Random", systemImage: "dice")
                        }
                        
                        if !viewModel.allTags.isEmpty {
                            Picker("Filter by Tag", selection: $viewModel.selectedTag) {
                                Text("All").tag(nil as String?)
                                ForEach(viewModel.allTags, id: \.self) { tag in
                                    Text(tag).tag(tag as String?)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddFriend) {
                AddEditFriendView(mode: .add) { newFriend in
                    Task { await viewModel.addFriend(newFriend) }
                }
            }
            .sheet(isPresented: $viewModel.showingRandomFriendsSheet) {
                RandomFriendsView { count in
                    Task { await viewModel.generateRandomFriends(count: count) }
                }
            }
        }
        .task { await viewModel.fetchFriends() }
        .refreshable { await viewModel.fetchFriends() }
    }
    
    private var currentFriends: [Friend] {
        let friends = selectedTab == .all ? viewModel.filteredFriends : viewModel.favoriteFriends
        return friends.sorted { $0.name < $1.name }
    }
}

struct EmptyStateView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            VStack(spacing: 4) {
                Text(searchText.isEmpty ? "No Friends Yet" : "No Matches Found")
                    .font(.headline)
                
                Text(searchText.isEmpty ? "Add your first friend to get started" : "Try a different search term")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
