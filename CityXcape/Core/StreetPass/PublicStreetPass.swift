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

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    let manager = NotificationsManager.instance

    let width: CGFloat = UIScreen.main.bounds.size.width / 5
    var body: some View {
        
        
        ZStack(alignment: .topLeading) {
            Color.streePass
                .edgesIgnoringSafeArea(.all)
            
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.orange,]), startPoint: .center, endPoint: .bottom)
                            .cornerRadius(25)
            
            VStack {
                
                HStack {
                    Text("StreetPass".uppercased())
                          .foregroundColor(.white)
                          .fontWeight(.thin)
                          .tracking(5)
                          .font(.title)
                          .padding()
                          .padding(.leading, 20)
                    
                    Spacer()
                }
            

                Spacer()
                    .frame(height: width)
                
                HStack {
                     Spacer()
                     VStack(alignment: .center) {
                         Button(action: {
                             
                         }, label: {
                             UserDotView(imageUrl: user.profileImageUrl, width: 250)
                                 .shadow(radius: 5)
                                 .shadow(color: .orange, radius: 30, x: 0, y: 0)
                         })
                       
                         
                         Text(user.displayName)
                             .fontWeight(.thin)
                             .foregroundColor(.accent)
                             .tracking(2)
                             .padding()
                         
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
                            streetFollowerUser(fcm: token)
                        } else {
                            alertMessage = "CityXcape needs notification permission allowed"
                            showAlert.toggle()
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
            .alert(isPresented: $showAlert) {
                AnalyticsService.instance.triedMessagingUser()
                return Alert(title: Text(alertMessage))
            }
            
        }
        
        
        
    }
    //End of body
    
    fileprivate func streetFollowerUser(fcm: String) {
        DataService.instance.streetFollowUser(user: user, fcmToken: fcm) { succcess in
            if succcess {
                self.alertMessage = "Following \(user.displayName)"
                self.showAlert = true
            } else {
                self.alertMessage = "Cannot follow \(user.displayName)"
                self.showAlert = true
            }
        }
    }

   
}

struct PublicStreetPass_Previews: PreviewProvider {
    
    static var previews: some View {
        let user = User(id: "abc123", displayName: "Cinquain", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073")
       PublicStreetPass(user: user)
    }
}
