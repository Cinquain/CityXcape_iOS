//
//  PublicStreetPass.swift
//  CityXcape
//
//  Created by James Allan on 11/2/21.
//
import Shimmer
import SwiftUI
import FirebaseMessaging

struct PublicStreetPass: View {
    
    @State var user: User

   
    @State private var instagram: String = ""
    @State private var showRanks: Bool = false
    @State private var showJourney: Bool = false
    @State private var showRequest: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: JourneyViewModel = JourneyViewModel()
    let manager = NotificationsManager.instance

    let width: CGFloat = UIScreen.main.bounds.size.width / 5
    
    var body: some View {
                    
            VStack {
                
                headerTitle

                Spacer()
                    .frame(height: width)
                
                HStack {
                     Spacer()
                     VStack(alignment: .center) {
                         
                         if vm.showJourney {
                             withAnimation(.easeOut(duration: 0.4)) {
                                 JourneyMap(vm: vm, verifications: vm.verifications)
                                     .colorScheme(.dark)
                             }
                         } else {
                             withAnimation(.easeOut(duration: 0.4)) {
                                 UserDotView(imageUrl: user.profileImageUrl, width: 250)
                                     .shadow(radius: 5)
                                     .shadow(color: .orange, radius: 30, x: 0, y: 0)
                             }
                         
                         }
                        
                         
                         VStack(spacing: 0) {
                             HStack(alignment: .bottom) {
                                 VStack {
                                     Text(user.displayName)
                                         .fontWeight(.thin)
                                         .foregroundColor(.accent)
                                         .tracking(2)
                                     
                                     ranksButton
                                 }
                                 
                                 if user.social != nil {
                                    instaButton
                                 }

                             }
                             .padding(.top, 10)
                             
                             if user.newFriend ?? false {
                                friendRequestView
                             }
                          
                             journeyButton
                           
                             
                         }
                          
                     }
                     Spacer()
                 }
                
                
                Spacer()
                    .frame(height: width / 1.5)
                
                threeButtons
                
                if vm.friends.contains(where: {$0.id == user.id}) {
                    withAnimation {
                        messageButton
                    }
                }
                            
                Spacer()
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.orange,]), startPoint: .center, endPoint: .bottom).edgesIgnoringSafeArea(.all))
            .alert(isPresented: $vm.showAlert) {
                return Alert(title: Text(vm.alertMessage))
            }
           
        
    }
    //End of body
   
}

extension PublicStreetPass {
    
    private var friendRequestView: some View {
        VStack {
            Text("Wants to be Friends")
                .font(.title3)
                .foregroundColor(.white)
                .fontWeight(.thin)
                .shimmering(active: true, duration: 1.4, bounce: true)
            
            HStack {
                Button {
                    vm.tappedNo.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        user.newFriend = false
                        vm.tappedNo.toggle()
                    }
                } label: {
                    VStack(spacing: 0) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .foregroundColor(vm.tappedNo ? .red : .black)
                            .animation(.easeOut)
                        Text("Nah")
                            .font(.callout)
                            .fontWeight(.thin)
                            .foregroundColor(vm.tappedNo ? .red : .black)

                    }
                    .foregroundColor(.black)

                }
                
                Spacer()
                
                Button {
                    vm.acceptFriendRequest(user: user) {
                        user.newFriend = false
                    }
                } label: {
                    VStack(spacing: 0) {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .foregroundColor(vm.tappedYes ? .green : .black)
                            .animation(.easeOut)
                        Text("Yes")
                            .font(.callout)
                            .fontWeight(.thin)
                            .foregroundColor(vm.tappedYes ? .green : .black)
                    }

                }


            }
            .frame(width: 120)
        }
        .animation(.easeOut(duration: 1), value: showRequest)
    }
    
    
    private var threeButtons: some View {
        HStack {

            Button {
                manager.checkAuthorizationStatus { fcmToken in
                    if let token = fcmToken {
                        vm.streetFollowerUser(fcm: token, user: user)
                    } else {
                        vm.alertMessage = "CityXcape needs notification permission to follow user"
                        vm.showAlert.toggle()
                    }
                }
            } label: {
                Image("streetfollow")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
            }
            
            
            Button {
                vm.showSecretSpots()
            } label: {
                Image("share_2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
            }
            .sheet(isPresented: $vm.showSpotList) {
                ShareSpotView(user: user, vm: vm)
            }
            
            Button {
                manager.checkAuthorizationStatus { fcmToken in
                    if let token = fcmToken {
                        vm.sendFriendRequest(uid: user.id, token: token)
                    } else {
                        vm.alertMessage = "CityXcape needs notification permission to send friend request"
                        vm.showAlert.toggle()
                    }
                }
            } label: {
                Image("request")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
            }
        }
    }
    
    private var messageButton: some View {
        Button {
             vm.showChatLog.toggle()
             AnalyticsService.instance.sentMessage()
         } label: {
           
             Text("messeage")
                 .fontWeight(.thin)
                 .foregroundColor(.cx_orange)
                 .frame(width: 200, height: 45)
                 .background(.black)
                 .cornerRadius(25)
         }
         .sheet(isPresented: $vm.showChatLog) {
             ChatLogView(user: user)
         }
                 
    }
    
    private var journeyButton: some View {
        Button {
            vm.showJourney ? vm.showJourney.toggle() :
            vm.getVerificationForUser(userId: user.id)
        } label: {
            HStack {
                Image("Footprints")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .opacity(0.8)
                
                Text("Their Journey")
                    .fontWeight(.thin)
            }
        }
        .padding(.top, 10)
        .sheet(item: $vm.verification) { verification in
            PublicStampView(verification: verification)
        }
    }
    
    private var instaButton: some View {
        Button {
            vm.openInstagram(username: user.social ?? "")
        } label: {
            Image("instagram")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
        }
    }
    
    private var ranksButton: some View {
        Button {
            showRanks.toggle()
        } label: {
            Text(user.rank ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .sheet(isPresented: $showRanks) {
            Ranks()
        }
    }
    
    private var headerTitle: some View {
        HStack {
            if vm.showJourney {
                UserDotView(imageUrl: user.profileImageUrl, width: 40)
            }
            VStack(alignment: .leading) {
                Text("\(user.displayName)'s")
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                Text("StreetPass".uppercased())
                      .foregroundColor(.white)
                      .fontWeight(.thin)
                      .tracking(5)
                  .font(.title2)
            }

            Spacer()
         
        }
        .padding()
    }
    
    //end of extension
}

struct PublicStreetPass_Previews: PreviewProvider {
    
    static var previews: some View {
        let user = User(id: "abc123", displayName: "Cinquain", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073")
       PublicStreetPass(user: user)
    }
}
