//
//  SettingsEditImageView.swift
//  CityXcape
//
//  Created by James Allan on 8/27/21.
//

import SwiftUI

struct SettingsEditImageView: View {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    
    @State var title: String
    @State var description: String
    @State var selectedImage: UIImage = UIImage(named: "User")!
    @State var showImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        
        VStack(spacing: 20) {
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
            
                    Button(action: {
                        showImagePicker.toggle()
                    }, label: {
                            Image(Icon.dot.rawValue)
                                .resizable()
                                .frame(width: 300 , height: 300)
                                .shadow(color: .orange, radius: 30, x: 0, y: 0)
                                .overlay(
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(150)
                                )
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

    }
    
    fileprivate func saveProfileImage() {
        guard let uid = userId else {return}
        
        ImageManager.instance.uploadProfileImage(uid: uid, image: selectedImage) { imageurl in
            
            guard let url = imageurl else {return}
            UserDefaults.standard.set(url, forKey: CurrentUserDefaults.profileUrl)
            
            DataService.instance.updateProfileImage(userId: uid, profileImageUrl: url)
            
        }
    }
}

struct SettingsEditImageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsEditImageView(title: "Title", description: "Description", selectedImage: UIImage(named: "User")!)
        }
    }
}
