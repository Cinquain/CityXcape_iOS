//
//  PublicStreetPass.swift
//  CityXcape
//
//  Created by James Allan on 11/2/21.
//

import SwiftUI
import FirebaseMessaging

struct PublicStreetPass: View {
    
    var user: User

   
    @State private var instagram: String = ""
    @State private var showJourney: Bool = false

    @StateObject var vm: PublicStreetPassVM = PublicStreetPassVM()
    let manager = NotificationsManager.instance

    let width: CGFloat = UIScreen.main.bounds.size.width / 5
    
    var body: some View {
                    
            VStack {
                
                HStack {
                    Text("StreetPass".uppercased())
                          .foregroundColor(.white)
                          .fontWeight(.thin)
                          .tracking(5)
                          .font(.title)
                         

                    Spacer()
                    
                 
                }
                .padding()
            

                Spacer()
                    .frame(height: width)
                
                HStack {
                     Spacer()
                     VStack(alignment: .center) {
                         
                         if vm.showJourney {
                             withAnimation(.easeOut(duration: 0.4)) {
                                 JourneyMap(verifications: vm.verifications)
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
                                 Text(user.displayName)
                                     .fontWeight(.thin)
                                     .foregroundColor(.accent)
                                     .tracking(2)
                                 
                                 if user.social != nil {
                                     Button {
                                         vm.openInstagram(username: user.social ?? "")
                                     } label: {
                                         Image("instagram")
                                             .resizable()
                                             .scaledToFit()
                                             .frame(width: 15)
                                     }
                                 }

                             }
                             .padding(.top, 10)

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
                         }
                         
                         //Need a text liner for the bio
                         VStack(spacing: 5) {
                             Text(user.bio ?? "")
                                 .font(.subheadline)
                                 .foregroundColor(.gray)
                             
                             if user.streetCred != nil {
                                 Button {
                                   
                                 } label: {
                                    
                                     Text("\(user.streetCred ?? 0) StreetCred")
                                         .font(.caption)
                                         .foregroundColor(.gray)
                                 }
                             }
                            
                         }
         
                        
                             
                     }
                     Spacer()
                 }
                
                Spacer()
                    .frame(height: width / 1.5)
                
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
                    
                    Text("Street Follow")
                        .fontWeight(.light)
                  
                }
                .padding()
                .frame(width: 220)
                .frame(height: 45)
                .background(Color.orange.opacity(0.7))
                .cornerRadius(25)

                

            
                Spacer()
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.orange,]), startPoint: .center, endPoint: .bottom).edgesIgnoringSafeArea(.all))
            .alert(isPresented: $vm.showAlert) {
                return Alert(title: Text(vm.alertMessage))
            }
        
    }
    //End of body
   
}

struct PublicStreetPass_Previews: PreviewProvider {
    
    static var previews: some View {
        let user = User(id: "abc123", displayName: "Cinquain", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073")
       PublicStreetPass(user: user)
    }
}
