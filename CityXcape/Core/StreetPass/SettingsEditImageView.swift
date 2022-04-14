//
//  SettingsEditImageView.swift
//  CityXcape
//
//  Created by James Allan on 8/27/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SettingsEditImageView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(CurrentUserDefaults.userId) var userId: String?

    
    @Binding var profileUrl: String
    @State var title: String
    @State var description: String
    @State var selectedImage: UIImage = UIImage(named: "silhouette")!
    @State var showImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSuccessAlert: Bool = false
    
    
    var body: some View {
        
        VStack(spacing: 20) {
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
            
                    Button(action: {
                        showImagePicker.toggle()
                    }, label: {
                        UserDotView(imageUrl: profileUrl, width: 250)
                            .shadow(radius: 5)
                            .shadow(color: .orange, radius: 30, x: 0, y: 0)
                    })
           
        
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                Text("Import".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .cornerRadius(12)
            })
            .accentColor(Color.purple)
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
                    .colorScheme(.dark)
            })
            
            Button(action: {
                saveProfileImage()
            }, label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(12)
            })
            .accentColor(Color.orange)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationBarTitle(title)
        .alert(isPresented: $showSuccessAlert, content: {
            return Alert(title: Text("Success 🥳"), message: nil, dismissButton: .default(Text("Ok"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
        })

    }
    
    fileprivate func saveProfileImage() {
        guard let uid = userId else {return}
        
        ImageManager.instance.uploadProfileImage(uid: uid, image: selectedImage) { imageurl in
            
            guard let url = imageurl else {return}
            profileUrl = url
            UserDefaults.standard.set(url, forKey: CurrentUserDefaults.profileUrl)
            
            DataService.instance.updateProfileImage(userId: uid, profileImageUrl: url)
            self.showSuccessAlert.toggle()
        }
    }
}

struct SettingsEditImageView_Previews: PreviewProvider {
    @State static var teststring = ""
    static var previews: some View {
        NavigationView {
            SettingsEditImageView(profileUrl: $teststring, title: "Title", description: "Description", selectedImage: UIImage(named: "User")!)
        }
    }
}
