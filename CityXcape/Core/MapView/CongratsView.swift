//
//  CongratsView.swift
//  CityXcape
//
//  Created by James Allan on 8/31/21.
//

import SwiftUI
import FirebaseMessaging

struct CongratsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @State private var presentAlert: Bool  = false

    

    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                
               
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]), startPoint: .center, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                        .frame(maxHeight: geo.size.height / 6)
                    
                    Text("Congratulations!")
                        .font(.title)
                        .fontWeight(.thin)
                   
                    Image(Icon.pin.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width, height: geo.size.width / 1.8)
                    
                    Text("You Earned 1 StreetCred")
                        .font(.title3)
                        .fontWeight(.thin)
                        .shimmering()
                    
                    
                  
                    Spacer()
                        .frame(maxHeight: geo.size.height / 9)
                    
                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            checkforNotifications()
                            AnalyticsService.instance.postSecretSpot()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        HStack {
                            Image(Icon.check.rawValue)
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Done!")
                                .font(.caption)
                        }
                    })
                    .padding()
                    .frame(width: 150, height: 50)
                    .background(Color.black.opacity(0.9))
                    .foregroundColor(.blue)
                    .cornerRadius(5)
                    
                }
                .foregroundColor(.white)
                
            
                
            }
        }
    }
    
    
    fileprivate func checkforNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                print("Notification is authorized")
                return
            case .denied:
                //request notification & save FCM token to DB
                print("Authorization Denied!")
                requestForNotification()
            case .notDetermined:
                //request notification & save FCM token to DB
                requestForNotification()
                print("Authorization Not determined")
            case .ephemeral:
                print("Notificaiton is ephemeral")
                return
            @unknown default:
                return
            }
            
            
        }
    }
    
    fileprivate func requestForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            if let error = error {
                print("Error getting notification permission", error.localizedDescription)
            }
            
            
            if granted {
                print("Notification access granted")
                let fcmToken = Messaging.messaging().fcmToken ?? ""
                guard let uid = userId else {return}

                let data = [
                    UserField.fcmToken: fcmToken
                ]
                
                AuthService.instance.updateUserField(uid: uid, data: data)
            } else {
                print("Notification Authorization denied")
            }
            
        }
    }
    
}

struct CongratsView_Previews: PreviewProvider {
    static var previews: some View {
        CongratsView()
    }
}
