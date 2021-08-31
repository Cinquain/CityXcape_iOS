//
//  SettingsView.swift
//  CityXcape
//
//  Created by James Allan on 8/24/21.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
  
    
    var body: some View {
        
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                //MARK: SECTION 1: CITYXCAPE
                GroupBox(label: SettingsLabelView(labelText: "CityXcape", labelImage: "dot.radiowaves.left.and.right"), content: {
                    HStack(alignment: .center, spacing: 10, content: {
                        Image("pin_blue")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.black)
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .center)
                            .padding()
                        Text("CityXcape is an app to save your spots in one place. You can also use this app to discover the secret spots of other explorers.")
                            .font(.footnote)
                    })
                })
                .padding()
                
                
                //MARK: SECTION 2: PROFILE
                
                GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill"), content: {
                    
                    NavigationLink(
                        destination: SettingsEditTextView(submissionText: "Current Street Name", title: "Streetname", description: "Edit your Street Name here. Your Streetname is searchable by other users.", placeHolder: "Your street name here..."),
                        label: {
                            SettingsRowView(text: "Display Name", leftIcon: "pencil", color: .cx_blue)
                        })

                    
                    NavigationLink(
                        destination: SettingsEditTextView(submissionText: "Current Bio", title: "Profile Bio", description: "Your bio is a great place to let other users know a little bit about you.", placeHolder: "Your bio here..."),
                        label: {
                            SettingsRowView(text: "Bio", leftIcon: "text.quote", color: .cx_blue)
                        })
                    
                    NavigationLink(
                        destination: SettingsEditImageView(title: "Profile Picture", description: "Your profile picture will be shown on your streetpass and on the secret spots you post. Please make it an image of yourself", selectedImage: UIImage(named: "User")!),
                        label: {
                            SettingsRowView(text: "Profile Picture", leftIcon: "photo", color: .cx_blue)
                        })
                    
                    
                    SettingsRowView(text: "Sign out", leftIcon: "figure.walk", color: .cx_blue)

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
                    Text("Made by James Allan. \n All Rights Reserved \n CityXcape Inc. \n Copyright 2021" )
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
    }
    
    //MARK: FUNCTIONS
    
    func openCustomURL(urlstring: String) {
        guard let url = URL(string: urlstring) else {return}
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
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
    static var previews: some View {
        SettingsView()

    }
}
