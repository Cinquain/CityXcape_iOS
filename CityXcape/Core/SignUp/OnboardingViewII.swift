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
        
        GeometryReader { geo in
            
            VStack(spacing: 20) {
                Spacer()
                    .frame(height: geo.size.width / 5)
                
       
                
                HStack(alignment: .center) {
     
                    Button(action: {
                        showPicker.toggle()
                    }, label: {
                        VStack(spacing: 25){
                            Image(Icon.dot.rawValue)
                                .resizable()
                                .frame(width: geo.size.width / 2, height: geo.size.width / 2)
                                .shadow(color: .orange, radius: 30, x: 0, y: 0)
                                .overlay(
                                    Image(uiImage: userImage ?? UIImage())
                                        .resizable()
                                        .frame(width: geo.size.width / 3, height: geo.size.width / 3)
                                        .cornerRadius((geo.size.width / 3) / 2)
                                )
                            Text(displayName)
                                .font(.title3)
                                .fontWeight(.thin)
                        }
                    })
                }
            
                TextField("Create a Username", text: $displayName)
                    .placeholder(when: displayName.isEmpty) {
                        Text("Create a Username").foregroundColor(.gray)
                }
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .dark ? Color.orange.opacity(0.5) : .white)
                    .cornerRadius(8)
                    .font(.headline)
                    .autocapitalization(.sentences)
                    .padding(.horizontal)
                
                
                Button(action: {
                    showPicker.toggle()
                }, label: {
                    Text("Finish: Add Profile Picture")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(8)
                        .opacity(displayName.count > 3 ? 1.0 : 1.0)
                        .animation(.easeOut(duration: 1.0))
                        .padding(.horizontal)
                })
                
                ProgressView()
                    .frame(width: 100, height: 100)
                    .progressViewStyle(.circular)
                    .colorScheme(.dark)
                    .opacity(disableInteraction ? 1 : 0)
                
                Spacer()
                    .frame(height: 60)
                
                Button(action: {
                    createProfile()
                }, label: {
                    HStack {
                        Image(Icon.check.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        
                        Text(buttonMessage)
                            .font(.title3)
                            .foregroundColor(.black)
                            .fontWeight(.light)
                            
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(3)
                    .shadow(color: .white, radius: 5, x: 0, y: 0)
                })
                .opacity(opacity)
                .animation(.easeOut(duration: 0.5))
                .disabled(disableInteraction)
                


                
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
            if let userId = uid {
                
                AuthService.instance.loginUserToApp(userId: userId) { (success) in
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

struct OnboardingViewII_Previews: PreviewProvider {
    @State static var testString: String = "Cinquain"
    static var previews: some View {
        OnboardingViewII(email: $testString, name: $testString, providerId: $testString, provider: $testString)
    }
}
