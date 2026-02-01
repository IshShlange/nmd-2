import SwiftUI

struct ProfileView: View {
    @State private var profile = UserProfile()
    @State private var validationMessage = ""
    @State private var saveMessage = ""
    
    private let store = UserDefaultsStore()
    
    var isFormValid: Bool {
        !profile.name.isEmpty &&
        profile.email.contains("@") && profile.email.contains(".") &&
        profile.age > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("User Profile") {
                    TextField("Name", text: $profile.name)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Email", text: $profile.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    Stepper("Age: \(profile.age)", value: $profile.age, in: 0...120)
                }
                
                Section {
                    Button("Save") {
                        saveProfile()
                    }
                    .disabled(!isFormValid)
                    
                    Button("Clear", role: .destructive) {
                        clearProfile()
                    }
                }
                
                if !validationMessage.isEmpty {
                    Section {
                        Text(validationMessage)
                            .foregroundColor(.red)
                    }
                }
                
                if !saveMessage.isEmpty {
                    Section {
                        Text(saveMessage)
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                loadProfile()
            }
        }
    }
    
    private func saveProfile() {
        if isFormValid {
            store.save(profile: profile)
            saveMessage = "Profile saved successfully!"
            validationMessage = ""
            
            // Автоматически скрыть сообщение через 3 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                saveMessage = ""
            }
        } else {
            validationMessage = "Please fill all fields correctly"
        }
    }
    
    private func loadProfile() {
        if let savedProfile = store.load() {
            profile = savedProfile
            saveMessage = "Profile loaded from storage"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                saveMessage = ""
            }
        }
    }
    
    private func clearProfile() {
        store.clear()
        profile = UserProfile()
        saveMessage = "Profile cleared"
        validationMessage = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            saveMessage = ""
        }
    }
}