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
                      Image(uiImage: image)
                          .resizable()
                          .aspectRatio(contentMode: .fit)
                          .frame(width: 130)
                          .clipShape(Circle())
                  } else {
                      Image("profile")
                          .resizable()
                          .aspectRatio( contentMode: .fit)
                          .frame(width: 150)
                  }
              }
          }
    }
    
    private var finishButton: some View {
        
           Button {
               
               if isLogin {
                   vm.login { success in
                       if success {
                           self.presentationMode.wrappedValue.dismiss()
                       } else {
                           alertMessage = vm.message
                           showAlert.toggle()
                       }
                   }
               } else {
                   vm.createNewAccount { success in
                       if success {
                           self.presentationMode.wrappedValue.dismiss()
                       } else {
                           alertMessage = vm.message
                           showAlert.toggle()
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
    }
    
}

struct SignInWithEmail_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailView()
    }
}
