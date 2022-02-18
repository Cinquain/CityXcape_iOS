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
        
           Spacer()
            
            VStack(spacing: 10) {
               
                Picker("Picker", selection: $isLogin) {
                    Text("Login")
                        .tag(true)
                        .foregroundColor(.white)
                    
                    Text("Create Account")
                        .tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .colorScheme(.dark)
                .padding()
                
                if isLogin {
                    Image("logo")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(height: 50)
                        .padding(.bottom, 30)
                }
                
                if !isLogin {
                    Button {
                        vm.showPicker.toggle()
                    } label: {
                        VStack(spacing: 0) {
                            Image("profile")
                                .resizable()
                                .aspectRatio( contentMode: .fit)
                                .frame(width: 150)
                                .overlay(
                                    Image(uiImage: vm.userImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 130)
                                        .clipShape(Circle())
                            )
                            
                     Text("Tap to add profile image")
                                .font(.caption)
                                .fontWeight(.thin)
                                .foregroundColor(.white)
                                .opacity(vm.addedPic ? 0 : 1)
                        }
                    }
                    
                    TextField("Username", text: $vm.username)
                        .placeholder(when: vm.username.isEmpty) {
                            Text("Username").foregroundColor(.gray)
                    }
                        .keyboardType(.emailAddress)
                        .frame(width: vm.width * 0.9, height: 40)
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 6))
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 0.7)
                        )
                    
                    
                }
                
                TextField("Email", text: $vm.email)
                    .placeholder(when: vm.email.isEmpty) {
                        Text("Email").foregroundColor(.gray)
                }
                    .keyboardType(.emailAddress)
                    .frame(width: vm.width * 0.9, height: 40)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 6))
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 0.7)
                            .clipped()

                    )
                    

                    
                TextField("Password", text: $vm.password)
                    .placeholder(when: vm.password.isEmpty) {
                        Text("Password").foregroundColor(.gray)
                }
                    .frame(width: vm.width * 0.9, height: 40)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 6))
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 0.7)
                    )
                
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
                    
                    Text(isLogin ? "Login" : "Create Account")
                        .font(.subheadline)
                        .foregroundColor(isLogin ? .black : .white)
                        .fontWeight(.light)
                
                   
                }
                .frame(width: 170, height: 40)
                .background(isLogin ? Color.white : Color.dark_grey)
                .cornerRadius(25)
                .padding(.top, 20)
                .disabled(vm.disable)

                   
                
                Spacer()
                
            }
            .frame(width: vm.width, height: isLogin ? vm.height : vm.height + 150)
            .background(Color.black)
            .animation(.easeOut)
            .cornerRadius(12)
            .shadow(color: .white, radius: 1)

            
            Spacer()
        }
        .frame(width: UIScreen.screenWidth)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.cx_orange,]), startPoint: .center, endPoint: .bottom).edgesIgnoringSafeArea(.all))
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

struct SignInWithEmail_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailView()
    }
}
