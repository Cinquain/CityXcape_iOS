//
//  StreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/21/21.
//

import SwiftUI
import UIKit

struct StreetPass: View {
    
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    
    @State var userImage: UIImage = UIImage()
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var isPresented: Bool = false
    @State var presentSettings: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            Color.streePass
                .edgesIgnoringSafeArea(.all)
     
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.orange,]), startPoint: .center, endPoint: .bottom)
                .cornerRadius(25)
            
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    Text("StreetPass".uppercased())
                        .foregroundColor(.accent)
                        .fontWeight(.thin)
                        .tracking(5)
                        .font(.title)
                        .padding()
                    
                    Spacer()
                        .frame(height: geo.size.width / 5)
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Button(action: {
                                isPresented.toggle()
                            }, label: {
                                UserDotView(imageUrl: profileUrl ?? "", width: 250, height: 250)
                                    .shadow(radius: 5)
                                    .shadow(color: .orange, radius: 30, x: 0, y: 0)
                            })
                          
                            
                            Text("Cinquain")
                                .fontWeight(.thin)
                                .foregroundColor(.accent)
                                .tracking(2)
                        }
                        Spacer()
                    }
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            presentSettings.toggle()
                        }, label: {
                            Image(Icon.gear.rawValue)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .shadow(color: .black, radius: 10, x: 0.0, y: 0.0)
                        })
                        .padding(.all, 20)
                        .padding(.trailing, 20)
                    }
                }
                .sheet(isPresented: $isPresented, content: {
                    ImagePicker(imageSelected: $userImage, sourceType: $sourceType)
                        .colorScheme(.dark)
                })
                .fullScreenCover(isPresented: $presentSettings, content: {
                    SettingsView()
                })
              
            }
         
        }
    
        
    }
}

struct StreetPass_Previews: PreviewProvider {
    
    static var previews: some View {
        StreetPass()
    }
}
