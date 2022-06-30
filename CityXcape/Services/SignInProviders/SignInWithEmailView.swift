//
//  SignInWithEmail.swift
//  CityXcape
//
//  Created by James Allan on 2/9/22.
//

import SwiftUI

struct SignInWithEmailView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var vm: EmailSigninViewModel = EmailSigninViewModel()
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLogin: Bool = false
    @State private var disableInteraction: Bool = false
    var body: some View {
        
        VStack {
          
             Image("logo")
                 .resizable()
                 .aspectRatio( contentMode: .fit)
                 .frame(height: 50)
                 .padding(.bottom, 30)
            if !isLogin {
                withAnimation(.easeOut(duration: 0.3)) {
                    addImageButton
                }
            }
     
                 
            Form {
           
                Toggle(isLogin ?"Login" : "Signup", isOn: $isLogin)
                if !isLogin {
                    TextField("Create a username", text: $vm.username)
                }
                TextField("Email", text: $vm.email)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $vm.password)
                finishButton
            }
            .colorScheme(.dark)
            
            
        }
        .frame(width: UIScreen.screenWidth)
        .background(Color.black)
        .alert(isPresented: $showAlert) {
            return Alert(title: Text(alertMessage))
        }
        .fullScreenCover(isPresented: $vm.showPicker) {
            //TBD
            vm.addedPic = true
            hideKeyboard()
        } content: {
            ImagePicker(imageSelected: $vm.userImage, sourceType: $vm.sourceType)
                .colorScheme(.dark)
        }

        
    }
    

    
}

extension SignInWithEmailView {
    
    private var addImageButton: some View {
        Button {
              vm.showPicker.toggle()
          } label: {
              VStack(spacing: 0) {
                  if let image = vm.userImage {
                      ZStack {
                          Image(uiImage: image)
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 130)
                              .clipShape(Circle())
                          loadingCircle
                      }
                  } else {
                      ZStack {
                          Image("profile")
                              .resizable()
                              .aspectRatio( contentMode: .fit)
                              .frame(width: 150)
                          loadingCircle
                      }
                  }
              }
          }
    }
    
    private var loadingCircle: some View {
        ProgressView()
            .frame(width: 80, height: 80)
            .scaleEffect(3)
            .opacity(disableInteraction ? 1 : 0)
    }
    
    private var finishButton: some View {
        
           Button {
               
               if isLogin {
                   disableInteraction = true
                   vm.login { success in
                       if success {
                           self.presentationMode.wrappedValue.dismiss()
                       } else {
                           alertMessage = vm.message
                           showAlert.toggle()
                           disableInteraction = false
                       }
                   }
               } else {
                   disableInteraction = true
                   vm.createNewAccount { success in
                       if success {
                           self.presentationMode.wrappedValue.dismiss()
                       } else {
                           alertMessage = vm.message
                           showAlert.toggle()
                           disableInteraction = false
                       }
                   }
               }
               
         
           } label: {
               
               HStack {
                   Spacer()
                   Text(isLogin ? "Login" : "Create Account")
                    .font(.subheadline)
                   .fontWeight(.light)
                   .foregroundColor(.blue)
                   Spacer()
               }
           
              
           }
           .disabled(disableInteraction)
    }
    
}

struct SignInWithEmail_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailView()
    }
}
