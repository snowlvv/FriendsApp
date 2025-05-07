import SwiftUI

struct FriendDetailView: View {
   @Binding var friend: Friend
   @State private var isEditing = false
   
   var body: some View {
       Group {
           if isEditing {
               AddEditFriendView(mode: .edit(friend: friend)) { updatedFriend in
                   friend = updatedFriend
                   isEditing = false
               }
           } else {
               ScrollView {
                   VStack(spacing: 20) {
                       AvatarView(url: friend.avatar, size: 120)
                           .padding(.top, 20)
                       
                       VStack(spacing: 8) {
                           Text(friend.name)
                               .font(.title)
                               .fontWeight(.bold)
                           
                           if !friend.tags.isEmpty {
                               TagCloudView(tags: friend.tags)
                                   .padding(.horizontal)
                           }
                       }
                       
                       Divider()
                       
                       VStack(alignment: .leading, spacing: 16) {
                           InfoRowView(icon: "envelope", text: friend.email)
                           InfoRowView(icon: "phone", text: friend.phone)
                           
                           if !friend.address.isEmpty {
                               InfoRowView(icon: "house", text: friend.address)
                           }
                           
                           if friend.birthday != nil {
                               InfoRowView(icon: "gift", text: "\(friend.birthdayString) (\(friend.age ?? 0) years)")
                           }
                           
                           if !friend.notes.isEmpty {
                               VStack(alignment: .leading, spacing: 4) {
                                   Text("Notes")
                                       .font(.headline)
                                   Text(friend.notes)
                                       .foregroundColor(.secondary)
                               }
                           }
                       }
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .padding(.horizontal)
                   }
                   .padding(.bottom)
               }
               .background(Color.gray.opacity(0.1))
           }
       }
       .toolbar {
           ToolbarItem {
               Button(isEditing ? "Done" : "Edit") {
                   isEditing.toggle()
               }
           }
       }
   }
}

struct InfoRowView: View {
   let icon: String
   let text: String
   
   var body: some View {
       HStack {
           Image(systemName: icon)
               .frame(width: 30)
               .foregroundColor(.blue)
           Text(text)
           Spacer()
       }
       .padding()
       .background(Color.gray.opacity(0.1))
       .cornerRadius(10)
   }
}
