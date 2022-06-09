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
   
    
    @State var refresh: Bool = false
    @State var userImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var isPresented: Bool = false
    @State var presentSettings: Bool = false

    
    var body: some View {
        
        VStack {
    
            GeometryReader { geo in
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("StreetPass".uppercased())
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                            .tracking(5)
                            .font(.title)
                        
                        Spacer()
                        
                        if vm.totalStamps >= 0 {
                            PlugLight(on: $vm.plugMode, handleButton: vm.turnOnPlugMode)
                        }
                 
                    }
                    .padding()

                    
                    Spacer()
                        .frame(height: geo.size.width / 15)
                    
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Button(action: {
                                isPresented.toggle()
                            }, label: {
                                UserDotView(imageUrl: profileUrl, width: geo.size.width / 1.7)
                                    .shadow(radius: 5)
                                    .shadow(color: .orange, radius: 30, x: 0, y: 0)
                            })
                          
                            
                      
                                Text(username)
                                    .fontWeight(.thin)
                                    .foregroundColor(.accent)
                                    .tracking(2)
                                
                                
                                Button {
                                    vm.handleStreetCredAlert()
                                } label: {
                                    Text("\(streetCred) StreetCred")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            
                            Button {
                                    vm.showRanks.toggle()
                                } label: {
                                    VStack {
                                        Text("Current Rank: \(vm.rank)")
                                            .foregroundColor(.white)
                                        BarView(progress: vm.progressValue)
                                        Text(vm.progressString)
                                            .font(.caption)
                                            .fontWeight(.thin)

                                    }

                                }
                                .sheet(isPresented: $vm.showRanks) {
                                    Leaderboard(ranks: vm.ranking)
                            }
                                .padding(.top, 10)
                            
                                
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
                                     .frame(height: 30)
                                                             
                                    Text("My Journey")
                                         .font(.title2)
                                         .fontWeight(.thin)
                                         .foregroundColor(.white)
                                
                            }
                            .frame(width: 150, height: 30)
                        
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
                                    .frame(height: 25)
                                 
                                   Text("Analytics")
                                        .font(.title2)
                                        .fontWeight(.thin)
                                        .foregroundColor(.white)
                                Spacer()

                        }
                        .frame(width: 150, height: 30)

                        }
                        .fullScreenCover(isPresented: $vm.showStats) {
                            StreetReportCard()
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
                                .frame(width: 35, height: 35)
                                .shadow(color: .black, radius: 10, x: 0.0, y: 0.0)
                        })
                        .padding(.all, 20)
                        .padding(.trailing, 20)
                    }
                    
                    
            //End of Geometry Reader
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
            
            //End of VStack
            }
            .onAppear(perform: {
                getAdditionalProfileInfo()
            })
            .alert(isPresented: $vm.showAlert) {
                return Alert(title: Text(vm.message))
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.orange,]), startPoint: .center, endPoint: .bottom)
                .cornerRadius(25).edgesIgnoringSafeArea(.all))
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
