import SwiftUI

struct FriendRowView: View {
    let friend: Friend
    var onFavoriteTapped: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 16) {
            AvatarView(url: friend.avatar, size: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.headline)
                
                if !friend.tags.isEmpty {
                    TagCloudView(tags: friend.tags)
                }
            }
            
            Spacer()
            
            Button(action: { onFavoriteTapped?() }) {
                Image(systemName: friend.favorite ? "heart.fill" : "heart")
                    .foregroundColor(friend.favorite ? .red : .gray)
                    .imageScale(.large)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}
