//
//  StreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/21/21.
//

import SwiftUI
import UIKit

struct StreetPass: View {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.bio) var bio: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    @AppStorage(CurrentUserDefaults.social) var social: Int?


    @StateObject var vm: StreetPassViewModel = StreetPassViewModel()
    
    
    @State private var username: String = ""
    @State private var userbio: String = ""
    @State private var profileUrl = ""
    @State private var instagram = ""
    @State private var streetCred : Int = 0
    @State private var showAlert : Bool = false
    @State private var message: String = ""
    
    @State var refresh: Bool = false
    @State var userImage: UIImage?
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
                    HStack {
                        Text("StreetPass".uppercased())
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                            .tracking(5)
                            .font(.title)
                        
                        Spacer()
                        
                        if !instagram.isEmpty {
                            Button {
                                vm.openInstagram(username: instagram)
                            } label: {
                                Image("instagram")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28)
                            }
                        }
                    }
                    .padding()

                    
                    Spacer()
                        .frame(height: geo.size.width / 5)
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Button(action: {
                                isPresented.toggle()
                            }, label: {
                                UserDotView(imageUrl: profileUrl, width: 250)
                                    .shadow(radius: 5)
                                    .shadow(color: .orange, radius: 30, x: 0, y: 0)
                            })
                          
                            
                            Text(username)
                                .fontWeight(.thin)
                                .foregroundColor(.accent)
                                .tracking(2)
                                .padding()
                            
                            //Need a text liner for the bio
                            VStack(spacing: 5) {
                                    Text(userbio)
                                            .font(.subheadline)
                                        .foregroundColor(.gray)
                                
                                
                                Button {
                                    message = "StreetCred is a currency that lets you save Secret Spots."
                                    AnalyticsService.instance.viewStreetpass()
                                    showAlert.toggle()
                                } label: {
                                    Text("\(streetCred) StreetCred")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
            
                                
                                
                        }
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        Button {
                            //TB
                            AnalyticsService.instance.checkedJournal()
                            vm.showJourney.toggle()
                        } label: {
                            HStack {
                                Image("Scout Life")
                                     .resizable()
                                     .scaledToFit()
                                     .frame(width: 35)
                                VStack(alignment: .leading) {
                             
                                    Text("My Journey")
                                         .font(.title2)
                                         .fontWeight(.thin)
                                         .foregroundColor(.white)
                                }
                            }
                        
                        }
                        .fullScreenCover(isPresented: $vm.showJourney) {
                            JourneyView()
                        }
                        
                        Spacer()
                   
                    }
                    .padding(.top, 20)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            //Show Stats
                            vm.showStats.toggle()
                        } label: {
                            HStack {
                               Image("graph")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35)
                               VStack(alignment: .leading) {
                                   Text("STREET")
                                       .fontWeight(.thin)
                                       .font(.caption)
                                       .tracking(5)
                                   Text("Report Card")
                                        .font(.title2)
                                        .fontWeight(.thin)
                                        .foregroundColor(.white)
                               }
                        }
                        }
                        .fullScreenCover(isPresented: $vm.showStats) {
                            StreetReportCard()
                        }
                        
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        Button {
                            //TB
                            AnalyticsService.instance.checkedStreetFollowers()
                            vm.showStreetFollowers.toggle()
                        } label: {
                            HStack {
                                Image("running")
                                     .resizable()
                                     .scaledToFit()
                                     .frame(height: 35)
                                VStack(alignment: .leading) {
                                    Text("STREET")
                                        .fontWeight(.thin)
                                        .font(.caption)
                                        .tracking(5)
                                    Text("Followers")
                                         .font(.title2)
                                         .fontWeight(.thin)
                                         .foregroundColor(.white)
                                         .padding(.trailing, 20)

                                }
                            }
                        
                        }
                        .fullScreenCover(isPresented: $vm.showStreetFollowers) {
                            StreetFollowersView(vm: vm)
                        }
                        
                        Spacer()
                   
                    }
                    
                    
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            AnalyticsService.instance.touchedSettings()
                            presentSettings.toggle()
                        }, label: {
                            Image(Icon.gear.rawValue)
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .shadow(color: .black, radius: 10, x: 0.0, y: 0.0)
                        })
                        .padding(.all, 20)
                        .padding(.trailing, 20)
                    }
                }
                .sheet(isPresented: $isPresented, onDismiss: {
                    updateProfielImage()
                }, content: {
                    ImagePicker(imageSelected: $userImage, sourceType: $sourceType)
                        .colorScheme(.dark)
                })
                .fullScreenCover(isPresented: $presentSettings, content: {
                    SettingsView(displayName: $username, userBio: $userbio, profileUrl: $profileUrl)
                })
                
              
            }
            .onAppear(perform: {
                getAdditionalProfileInfo()
            })
            .alert(isPresented: $showAlert) {
                return Alert(title: Text(message))
            }
        }
    

    }
    
    fileprivate func updateProfielImage() {
        
        guard let image = userImage else {return}
        if let uid = userId {
            ImageManager.instance.uploadProfileImage(uid: uid, image: image) { (imageUrl) in
                guard let url = imageUrl else {return}
                UserDefaults.standard.set(url, forKey: CurrentUserDefaults.profileUrl)
                
                DataService.instance.updateProfileImage(userId: uid, profileImageUrl: url)
                
                
                self.profileUrl = url
                
                //Update image url at every user's secret spot post
                DataService.instance.updatePostProfileImageUrl(profileUrl: url)
            }
        }
        
    }
    
    
    func getAdditionalProfileInfo() {
        guard let uid = userId else {return}
        AuthService.instance.getUserInfo(forUserID: uid) { username, bio, streetcred, profileUrl, social in
            
            if let name = username {
                self.username = name
                UserDefaults.standard.set(name, forKey: CurrentUserDefaults.displayName)
            }
            
            if let bio = bio {
                self.userbio = bio
                UserDefaults.standard.set(bio, forKey: CurrentUserDefaults.bio)
            }
            
            if let url = profileUrl {
                self.profileUrl = url
                UserDefaults.standard.set(url, forKey: CurrentUserDefaults.profileUrl)

            }
            
            if let streetCred = streetcred {
                self.streetCred = streetCred
                UserDefaults.standard.set(streetcred, forKey: CurrentUserDefaults.wallet)

            }
        
            if let ig = social {
                self.instagram = ig
            }
            
            
        }
    }
}

struct StreetPass_Previews: PreviewProvider {
    
    static var previews: some View {
        StreetPass()
    }
}
