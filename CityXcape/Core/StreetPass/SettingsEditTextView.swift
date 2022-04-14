//
//  SettingsEditTextView.swift
//  CityXcape
//
//  Created by James Allan on 8/24/21.
//

import SwiftUI

struct SettingsEditTextView: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(CurrentUserDefaults.userId) var userId: String?

    
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeHolder: String
    @State var options: SettingsEditTextOption
    @State private var showSuccessAlert: Bool = false
    @Binding var profileText: String
    
    
    var body: some View {
        
        VStack {
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
            TextField(placeHolder, text: $submissionText)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.1))
                .accentColor(.black)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
            
            
            Button(action: {
                saveText()
            }, label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(12)
                    .withPresstableStyle()
            })
            .accentColor(Color.orange)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleDisplayMode(.large)
        .alert(isPresented: $showSuccessAlert, content: {
            return Alert(title: Text("Saved! 🥳"), message: Text(""), dismissButton: .default(Text("Ok"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
        })
        
    }
    
    fileprivate func saveText() {
        guard let uid = userId else {return}

        switch options {
        case .displayName:
            
            //Update the UI on the profile
            self.profileText = submissionText
            //Update user defaults
            UserDefaults.standard.setValue(submissionText, forKey: CurrentUserDefaults.displayName)
            
            //Update the displayNames on DB user's spots
            DataService.instance.updateDisplayNameOnPosts(userId: uid, displayName: submissionText)
            //Update the displayName on user profile
            AuthService.instance.updateUserDisplayName(userId: uid, displayName: submissionText) { success in
                
                if success {
                    self.showSuccessAlert.toggle()
                }
                
            }
            
            break
        case .bio:
            self.profileText = submissionText
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.bio)
            AuthService.instance.updateUserBio(userId: uid, bio: submissionText) { success in
                if success {
                    AnalyticsService.instance.createdBio()
                    self.showSuccessAlert.toggle()
                }
            }
        case .social:
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.social)
            AuthService.instance.updateSocialMedia(uid: uid, ig: submissionText) { success in
                if success {
                    AnalyticsService.instance.updateSocialMedia()
                    self.showSuccessAlert.toggle()
                }
            }
        }
    
    }
}

struct SettingsEditTextView_Previews: PreviewProvider {
    @State static var teststring: String = ""
    static var previews: some View {
        NavigationView {
            SettingsEditTextView(title: "Edit Username", description: "Change Your Username", placeHolder: "Cinquain", options: .bio, profileText: $teststring)
        }
      
    }
}
