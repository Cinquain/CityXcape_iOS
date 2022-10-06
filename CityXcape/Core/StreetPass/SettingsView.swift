//
//  SettingsView.swift
//  CityXcape
//
//  Created by James Allan on 8/24/21.
//

import SwiftUI

struct SettingsView: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showSignoutError = false
  
    @Binding var displayName: String
    @Binding var userBio: String
    @Binding var profileUrl: String
    @State var showActionsheet: Bool = false
    @State private var showAlert: Bool = false
    @State private var message: String = ""
    
    var body: some View {
        
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                //MARK: SECTION 1: CITYXCAPE
                GroupBox(label: SettingsLabelView(labelText: "CityXcape", labelImage: "dot.radiowaves.left.and.right"), content: {
                    HStack(alignment: .center, spacing: 10, content: {
                        Image("pin_blue")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.text_Color)
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .center)
                            .padding()
                        Text("CityXcape is an app to save places you want to visit. For any questions, reach us at info@cityXcape.com")
                            .font(.footnote)
                    })
                })
                .padding()
                
                
                //MARK: SECTION 2: PROFILE
                
                GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill"), content: {
                    
                    NavigationLink(
                        destination: SettingsEditTextView(submissionText: displayName, title: "Streetname", description: "Edit your Street Name here. Your Streetname is searchable by other users.", placeHolder: "Your street name here...", options: .displayName, profileText: $displayName),
                        label: {
                            SettingsRowView(text: "Display Name", leftIcon: "pencil", color: .cx_blue)
                        })

                    
                    NavigationLink(
                        destination: SettingsEditTextView(submissionText: userBio, title: "Profile Bio", description: "Your bio is a great place to let other users know a little bit about you.", placeHolder: "Your bio here...", options: .bio, profileText: $userBio),
                        label: {
                            SettingsRowView(text: "Bio", leftIcon: "text.quote", color: .cx_blue)
                        })
                    
                    NavigationLink(
                        destination: SettingsEditTextView(submissionText: userBio, title: "Instagram", description: "Connect Instagram to your StreetPass", placeHolder: "Enter IG username", options: .social, profileText: $userBio),
                        label: {
                            SettingsRowView(text: "Instagram", leftIcon: "camera.circle.fill", color: .cx_blue)
                        })
                    
                    NavigationLink(
                        destination: SettingsEditImageView(profileUrl: $profileUrl, title: "Profile Picture", description: "Your profile picture will be shown on your streetpass and on the secret spots you post. Please make it an image of yourself", selectedImage: UIImage(named: "User")!),
                        label: {
                            SettingsRowView(text: "Profile Picture", leftIcon: "photo", color: .cx_blue)
                        })
                    
                    NavigationLink(
                        destination: StorePage(),
                        label: {
                            SettingsRowView(text: "Store", leftIcon: "cart.fill", color: .cx_blue)
                        })
                    
                    Button(action: {
                        signOut()
                    }, label: {
                        SettingsRowView(text: "Sign out", leftIcon: "figure.walk", color: .cx_blue)
                    })
                    .alert(isPresented: $showSignoutError, content: {
                        return Alert(title: Text("Error signing out 🥵"))
                    })
                    
                    
                    Button(action: {
                        showActionsheet.toggle()
                    }, label: {
                        SettingsRowView(text: "Delete Acccount", leftIcon: "trash", color: .red)
                    })
                    .alert(isPresented: $showSignoutError, content: {
                        return Alert(title: Text("Error signing out 🥵"))
                    })

                })
                .background(Color.white)
                .padding()
                
                
                
                //MARK: SECTION 3: APPLICATION
                GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone"), content: {
                    
                    Button(action: {
                        openCustomURL(urlstring: "https://www.cityxcape.com/privacy_policy")
                    }, label: {
                        SettingsRowView(text: "Privacy Policy", leftIcon: "folder.fill", color: .yellow)
                    })
                  
                    Button(action: {
                        openCustomURL(urlstring: "https://www.cityxcape.com/terms")
                    }, label: {
                        SettingsRowView(text: "Terms & Conditions", leftIcon: "doc.text.magnifyingglass", color: .yellow)
                    })
                    
                    Button(action: {
                        openCustomURL(urlstring: "https://www.cityxcape.com/store.html")
                    }, label: {
                        SettingsRowView(text: "Scout Merchandise", leftIcon: "globe", color: .yellow)
                    })
                 
                  
                })
                .padding()
                
                //MARK: SECTION 4: COPYRIGHTS
                
                GroupBox {
                    Text("Produced by James Allan. \n All Rights Reserved \n CityXcape Inc. \n Copyright 2021" )
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .padding(.bottom, 40)

            })
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                    })
                    .accentColor(.black)
            )
            
           
        }
        .alert(isPresented: $showAlert) {
            return Alert(title: Text(message))
        }
        .actionSheet(isPresented: $showActionsheet) {
            return ActionSheet(title: Text("Are you sure you want to delete?"), message: nil, buttons: [
                
                .destructive(Text("Yes"), action: {
                    delete()
                }),
                
                .cancel()
            ])
        }
        
        
    }
    
    //MARK: FUNCTIONS
    
    func openCustomURL(urlstring: String) {
        guard let url = URL(string: urlstring) else {return}
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        
    }
    
    func signOut() {
        AuthService.instance.logOutUser { (success) in
            if success {
                print("Successfully signed out user")
                self.presentationMode.wrappedValue.dismiss()

            } else {
                print("Error signout user")
                self.showSignoutError.toggle()
            }
        }
    }
    
    func delete() {
        AuthService.instance.deleteUser { success in
            if success {
                message = "Account Deleted"
                showAlert.toggle()
                self.presentationMode.wrappedValue.dismiss()
                signOut()

            } else {
                message = "Account Deleted!"
                showAlert.toggle()
                signOut()
            }
            
        }
    }
    
    
    
}


struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    
    @State static var testString: String = ""
    @State static var refresh: Bool = false
    static var previews: some View {
        SettingsView(displayName: $testString, userBio: $testString, profileUrl: $testString)
    }
}
