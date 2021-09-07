//
//  OnboardingView.swift
//  CityXcape
//
//  Created by James Allan on 8/21/21.
//

import SwiftUI
import FirebaseAuth

struct OnboardingView: View {
    
    @State var showError: Bool = false
    @State var showOnboardingII: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    @State var email: String = ""
    @State var name: String = ""
    @State var providerId: String = ""
    @State var provider: String = ""
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                    .frame(height: geo.size.width / 3)
            
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Image("fire")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: geo.size.height / 3)
                        Spacer()
                    }
                    Text("  CityXcape")
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .opacity(1)
                }
              
                Spacer()
                    .frame(height: 40)
                Button(action: {
                    SignInWithApple.instance.startSignInWithAppleFlow(view: self)
                }, label: {
                    SignInWithAppleButton()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                })
                
                Button(action: {
                    SignInWithGoogle.instance.startSignInWithGoogleFlow(view: self)
                }, label: {
                    HStack {
                        Image(Icon.globe.rawValue)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Sign in with Google")
                            .font(.title2)
                    }
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(8)
                    
                })
                Spacer()
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(Icon.back.rawValue)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding()
                    })
                   
                    Spacer()
                }
                .padding()
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $showOnboardingII, onDismiss: {
                self.presentationMode.wrappedValue.dismiss()
            }, content: {
                OnboardingViewII(email: $email, name: $name, providerId: $providerId, provider: $provider)
            })
            .alert(isPresented: $showError, content: {
                return Alert(title: Text("Error Signing In 😭"))
            })
        }
     
    }
    
    //MARK: FUNCTIONS
    func connectToFirebase(name: String, email: String, provider: String, credential: AuthCredential) {
        
        AuthService.instance.loginUserToFirebase(credential: credential) { (providerId, isError, isNewUser, returnedUserId) in
            
            if let newUser = isNewUser {
                
                
                if newUser {
                    //True means New User
                    if let providerId = providerId, !isError {
                        
                        self.name = name
                        self.email = email
                        self.providerId = providerId
                        self.provider = provider
                        self.showOnboardingII.toggle()
                    } else {
                        print("Error getting provider ID from login user to Firebase")
                        self.showError.toggle()
                    }
                    
                } else {
                    //False means Existing User
                    if let userId = returnedUserId {
                        
                        AuthService.instance.loginUserToApp(userId: userId) { (success) in
                            if success {
                                print("Successfully logged in existing user")
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                print("Error logging in existing user into app")
                                self.showError.toggle()
                            }
                        }
                    } else {
                        print("Error getting User ID from existing user to Firebase")
                    }
                    
                }
                
            } else {
                print("Error getting into from log in user to Firebase")
                self.showError.toggle()
            }
            
            
      
            
        }
    }
    
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
