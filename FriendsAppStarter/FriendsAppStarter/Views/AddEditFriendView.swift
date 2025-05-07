import SwiftUI

struct AddEditFriendView: View {
    enum Mode {
        case add
        case edit(friend: Friend)
    }
    
    let mode: Mode
    var onSave: (Friend) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var avatar: String = ""
    @State private var notes: String = ""
    @State private var favorite: Bool = false
    @State private var tags: [String] = []
    @State private var address: String = ""
    @State private var birthday: Date = Date()
    @State private var showTagInput: Bool = false
    @State private var newTag: String = ""
    
    private var title: String {
        switch mode {
        case .add: return "Add Friend"
        case .edit: return "Edit Friend"
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && email.contains("@")
    }
    
    init(mode: Mode, onSave: @escaping (Friend) -> Void) {
        self.mode = mode
        self.onSave = onSave
        
        if case let .edit(friend) = mode {
            _name = State(initialValue: friend.name)
            _email = State(initialValue: friend.email)
            _phone = State(initialValue: friend.phone)
            _avatar = State(initialValue: friend.avatar)
            _notes = State(initialValue: friend.notes)
            _favorite = State(initialValue: friend.favorite)
            _tags = State(initialValue: friend.tags)
            _address = State(initialValue: friend.address)
            _birthday = State(initialValue: friend.birthday ?? Date())
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                basicInfoSection
                additionalInfoSection
                tagsSection
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveFriend()
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var basicInfoSection: some View {
        Section(header: Text("Basic Information")) {
            TextField("Name *", text: $name)
            TextField("Email *", text: $email)
            TextField("Phone", text: $phone)
            TextField("Avatar URL", text: $avatar)
        }
    }
    
    private var additionalInfoSection: some View {
        Section(header: Text("Additional Information")) {
            Toggle("Favorite", isOn: $favorite)
            TextField("Address", text: $address)
            DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
            TextField("Notes", text: $notes)

        }
    }
    
    private var tagsSection: some View {
        Section(header: HStack {
            Text("Tags")
            Spacer()
            Button(action: { showTagInput.toggle() }) {
                Image(systemName: "plus")
            }
        }) {
            if showTagInput {
                HStack {
                    TextField("New Tag", text: $newTag)
                    Button("Add") {
                        withAnimation {
                            let trimmed = newTag.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty {
                                tags.append(trimmed)
                                newTag = ""
                            }
                        }
                    }
                    .disabled(newTag.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            
            if !tags.isEmpty {
                TagCloudView(tags: tags)
                    .padding(.vertical, 4)
            }
        }
    }
    
    private func saveFriend() {
        let friend = Friend(
            id: {
                if case let .edit(existing) = mode {
                    return existing.id
                }
                return UUID()
            }(),
            name: name,
            email: email,
            phone: phone,
            avatar: avatar.isEmpty ? "https://randomuser.me/api/portraits/lego/\(Int.random(in: 1...9)).jpg" : avatar,
            notes: notes,
            favorite: favorite,
            tags: tags,
            address: address,
            birthday: birthday
        )
        onSave(friend)
    }
}
