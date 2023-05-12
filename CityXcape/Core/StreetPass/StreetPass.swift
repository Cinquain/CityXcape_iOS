//
//  StreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/21/21.
//

import SwiftUI
import UIKit
import SDWebImageSwiftUI
import CryptoKit

struct StreetPass: View {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.bio) var bio: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    @AppStorage(CurrentUserDefaults.social) var social: Int?
    @AppStorage(CurrentUserDefaults.tribeImageUrl) var tribeImageUrl: String?

    @StateObject var vm: StreetPassViewModel

    @State private var username: String = ""
    @State private var userbio: String = ""
    @State private var profileUrl = ""
    @State private var instagram = ""
    @State private var streetCred : Double = 0
    @State private var user: User?
    @State private var membership: String = ""
    @State var videoUrl: URL?
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
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        
                        HStack {
                            
                            Spacer()
                            
                            Button(action: {
                                AnalyticsService.instance.touchedSettings()
                                presentSettings.toggle()
                            }, label: {
                                Image(Icon.gear.rawValue)
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .shadow(color: .black, radius: 10, x: 0.0, y: 0.0)
                            })
                        }
                    
                 
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer()
                        .frame(height: geo.size.width / 15)
                    
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Button(action: {
                                isPresented.toggle()
                            }, label: {
                                
                                PulseUserView(imageUrl: profileUrl, width: geo.size.width / 2)
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
                                    Text("\(String(format: "%.2f", streetCred)) StreetCred")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            
                                Spacer()
                                .frame(height: 20)
                            
                                Button {
                                    vm.showRanks.toggle()
                                } label: {
                                    VStack {
                                        WebImage(url: URL(string: tribeImageUrl ?? ""))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 200, height: 50)
                                            .opacity(0.8)
                                     
                                          
                                           
                                    }
                                }
                                .padding(.top, 10)
                                .animation(.easeIn)
                                .sheet(isPresented: $vm.showRanks) {
                                    Leaderboard(ranks: vm.ranking)
                                }
                                .opacity(user?.tribe != "" ? 1 : 0)
                              
                            
                                                        
                                
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
                                    .fullScreenCover(isPresented: $vm.showSignup) {
                                        OnboardingView()
                                    }

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
                    .padding(.top, 5)

                    
                    
                    
                    Spacer()
                    
                 
                    
                    
            //End of Geometry Reader
                }
                .sheet(isPresented: $isPresented, onDismiss: {
                    updateProfielImage()
                }, content: {
                    ImagePicker(imageSelected: $userImage, videoURL: $videoUrl, sourceType: $sourceType)
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
                return Alert(title: Text(vm.alertMessage), dismissButton: .default(Text("Ok"), action: {
                    vm.showSignup = true
                }))
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
        } else {
            vm.alertMessage = "You need an account to create a StreetPass"
            vm.showAlert = true
        }
        
    }
    
    
    func getAdditionalProfileInfo() {
        guard let uid = userId else {return}
        AuthService.instance.getUserInfo(forUserID: uid) { result in
            switch result {
            case .failure(let error):
                print("Error updating user",error.localizedDescription)
            case .success(let user ):
                self.user = user
                self.username = user.displayName
                self.userbio = user.bio ?? ""
                self.profileUrl = user.profileImageUrl
                self.streetCred = user.streetCred ?? 12.0
                self.membership = user.membership?.ribbonFormat() ?? ""
                if user.tribeImageUrl ?? "" != "" {
                    let url = user.tribeImageUrl ?? ""
                    let tribe = user.tribe ?? ""
                    let joinDate = user.membership?.ribbonFormat()
                    UserDefaults.standard.set(url, forKey: CurrentUserDefaults.tribeImageUrl)
                    UserDefaults.standard.set(tribe, forKey: CurrentUserDefaults.tribe)
                    UserDefaults.standard.set(joinDate, forKey: CurrentUserDefaults.tribeJoinDate)
                }

            }
        }
  
    }
    
    
}

struct StreetPass_Previews: PreviewProvider {

    static var previews: some View {
        StreetPass(vm: StreetPassViewModel())
            .environmentObject(StreetPassViewModel())
    }
}
