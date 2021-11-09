//
//  PublicStreetPass.swift
//  CityXcape
//
//  Created by James Allan on 11/2/21.
//

import SwiftUI

struct PublicStreetPass: View {
    
    let profileUrl: String
    let username: String
    let userbio: String
    let streetCred: String
    @State private var showAlert: Bool = false
    
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
                             UserDotView(imageUrl: profileUrl, width: 250, height: 250)
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
                               
                             } label: {
                                 Text("\(streetCred) StreetCred")
                                     .font(.caption)
                                     .foregroundColor(.gray)
                             }
                         }
         
                             
                             
                     }
                     Spacer()
                 }
                
                Spacer()
                    .frame(height: width / 1.5)
                
                Button {
                    print("Message User")
                    showAlert.toggle()
                } label: {
                    VStack {
                        Text("Message")
                            .lineLimit(2)
                    }
                   
                }
                .padding()
                .frame(width: 200)
                .frame(height: 45)
                .background(Color.orange.opacity(0.7))
                .cornerRadius(10)
                .disabled(true)


                
                Spacer()
                
            }
            .alert(isPresented: $showAlert) {
                AnalyticsService.instance.triedMessagingUser()
                return Alert(title: Text("Feature not yet available"))
            }
            
        }
        
        
        
    }
    //End of body

}

struct PublicStreetPass_Previews: PreviewProvider {
    
    static let text: String = "test"
    static let amount: Int = 10
    
    static var previews: some View {
        PublicStreetPass(profileUrl: text, username: text, userbio: text, streetCred: text)
    }
}
