//
//  OnboardingViewII.swift
//  CityXcape
//
//  Created by James Allan on 8/21/21.
//

import SwiftUI

struct OnboardingViewII: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme


    @State private var displayName = ""
    @State private var showPicker: Bool = false
    @State private var showActionSheet: Bool = false
    @State var userImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var opacity: Double = 0
    @State private var disableInteraction = false
    @State private var buttonMessage: String = "Create Account"

    @State var showError: Bool = false
    @State var message: String = ""
    
    @Binding var email: String
    @Binding var name: String
    @Binding var providerId: String
    @Binding var provider: String

    
    var body: some View {
        
            
            VStack(spacing: 20) {
                Spacer()
                    .frame(height: UIScreen.screenWidth / 5)
                
                
                HStack(alignment: .center) {
     
                    ZStack {
                        profileImageButton
                        loadingCircle
                    }
                    
                    
                }
                
                Form {
                    
                    TextField("Create a Username", text: $displayName)
                        .frame(height: 40)
                    addImageButton
                    finishButton
                    
                }
                .colorScheme(.dark)
        


                
                Spacer()
                
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $showPicker, onDismiss: {
                self.opacity = 1
                hideKeyboard()
            }, content: {
                ImagePicker(imageSelected: self.$userImage, sourceType: self.$sourceType)
                    .colorScheme(.dark)
                    
            })
            .alert(isPresented: $showError, content: {
                return Alert(title: Text(message))
            })
            .actionSheet(isPresented: $showActionSheet) {
                return ActionSheet(title: Text("Source Options"), message: nil, buttons: [
                    .default(Text("Camera"), action: {
                        sourceType = .camera
                        showPicker.toggle()
                    }),
                    .default(Text("Photo Library"), action: {
                        sourceType = .photoLibrary
                        showPicker.toggle()
                    }),
                    .cancel({
                        showActionSheet.toggle()
                    })
                ])
            }
            
        
    }
    
    fileprivate func createProfile() {
        
                
        print("Creating Profile")
        disableInteraction = true
        
        if displayName.count < 3 {
            self.showError = true
            message = "Username should be at least 3 characters 😤"
            disableInteraction = false
            return
        }
        
        if userImage == nil {
            message = "Upload a photo for your Streetpass"
            self.showError = true
            disableInteraction = false
            return
        }
        
        let image = userImage ?? UIImage()
        
        AuthService.instance.createNewUserInDatabase(name: displayName, email: email, providerId: providerId, provider: provider, profileImage: image) { (uid) in
            buttonMessage = "Creating Account"
            if let uid = uid {
                
                AuthService.instance.loginUserToApp(userId: uid) { (success) in
                    if success {
                        print("User logged in")
                        buttonMessage = "Account Created!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        print("Error logging in")
                        message = "Error creating profile 😤"
                        self.showError = true
                        buttonMessage = "Create Account"
                        disableInteraction = false
                    }
                   
                }
                
                
                //Error Creatign User in Database
            } else {
                print("Error creating user in database")
                message = "Error creating profile 😤"
                self.showError = true
                disableInteraction = false
                
            }
            
            
        }
    }
    
  
}


extension OnboardingViewII {
    
    private var profileImageButton: some View {
        Button(action: {
            showActionSheet.toggle()
        }, label: {
            VStack(spacing: 25){
                Image(Icon.dot.rawValue)
                    .resizable()
                    .frame(width: UIScreen.screenWidth / 2, height: UIScreen.screenWidth / 2)
                    .shadow(color: .orange, radius: 30, x: 0, y: 0)
                    .overlay(
                        Image(uiImage: userImage ?? UIImage())
                            .resizable()
                            .frame(width: UIScreen.screenWidth / 3, height: UIScreen.screenWidth / 3)
                            .cornerRadius((UIScreen.screenWidth / 3) / 2)
                    )
                Text(displayName)
                    .font(.title3)
                    .fontWeight(.thin)
            }
    })
        
    }
    
    private var loadingCircle: some View {
        ProgressView()
            .frame(width: 100, height: 100)
            .scaleEffect(3)
            .opacity(disableInteraction ? 1 : 0)
            .offset(y: -20)
    }
    
    private var addImageButton: some View {
        Button(action: {
            showActionSheet.toggle()
        }, label: {
            HStack(spacing: 8) {
                Image(systemName: "person.crop.circle")
                Text("Add Profile Picture")
                    
            }
        })
    }
    
    private var finishButton: some View {
        Button(action: {
            createProfile()
        }, label: {
            HStack {
               Spacer()
                Text(buttonMessage)
                    .fontWeight(.light)
                Spacer()
            }
            .foregroundColor(.blue)
        })
        .disabled(disableInteraction)
        
    }
    
}

struct OnboardingViewII_Previews: PreviewProvider {
    @State static var testString: String = "Cinquain"
    static var previews: some View {
        OnboardingViewII(email: $testString, name: $testString, providerId: $testString, provider: $testString)
    }
}
