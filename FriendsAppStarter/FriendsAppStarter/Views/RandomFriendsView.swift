import SwiftUI

struct RandomFriendsView: View {
    var onGenerate: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var count = 5
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Random Friends Generator")) {
                    Stepper(value: $count, in: 1...20) {
                        Text("Generate \(count) friends")
                    }
                }
                
                Section {
                    Button(action: generate) {
                        HStack {
                            Spacer()
                            Text("Generate")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Random Friends")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func generate() {
        onGenerate(count)
        dismiss()
    }
}
