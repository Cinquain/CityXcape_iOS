//
//  WorldInviteView.swift
//  CityXcape
//
//  Created by James Allan on 9/22/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Shimmer

struct WorldInviteView: View {
    @Environment(\.dismiss) var dismiss

    let world: World
    let width: CGFloat = UIScreen.screenWidth
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showInfo: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                WebImage(url: URL(string: world.imageUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(width: width / 2)
                    .opacity(0.6)
                Spacer()
            }
            .padding(.horizontal, 20)
            .foregroundColor(.white)
            
            WebImage(url: URL(string: world.coverImageUrl))
                .resizable()
                .scaledToFit()
                .frame(width: width)
                .overlay {
                    VStack {
                        Spacer()
                        
                        Text(world.description)
                            .fontWeight(.thin)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .opacity(showInfo ? 1 : 0)
                            .animation(.easeOut, value: showInfo)
                        
                        HStack {
                            Spacer()
                            Button {
                                showInfo.toggle()
                            } label: {
                                Image("info")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.bottom, 10)
                    }
                    .background(LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom))
                }
            
            HStack {
                HStack {
                    Image("dot")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    Text("\(world.memberCount) Members")
                        .fontWeight(.thin)
                }
                Spacer()
                HStack {
                    Image("pin_blue")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    
                    Text("\(world.spotCount) locations")
                        .fontWeight(.thin)
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            
            Text("Want to join this community?")
                .font(.title3)
                .fontWeight(.thin)
                .foregroundColor(.white)
                .padding(.top, 30)
                

            
            HStack(alignment: .center, spacing: 80) {
                
                
                    
                    Button {
                    DataService.instance.denyInvitation(name: world.name) { result in
                            switch result {
                            case .success(_), .failure(_):
                                alertMessage = "Invitation Denied"
                                showAlert.toggle()
                                dismiss()
                            }
                        }
                    } label: {
                        VStack(spacing: 2) {
                            Image("pass_dot")
                                .resizable()
                                .scaledToFit()
                            .frame(height: 55)
                            
                            Text("Nah...")
                                .font(.callout)
                                .fontWeight(.thin)
                                .foregroundColor(.white)
                        }
                       
                    }
                    
                    
                    Button {
                        DataService.instance.joinWorld(world: world) { result in
                            switch result {
                                case .failure(let error):
                                    alertMessage = error.localizedDescription
                                    showAlert.toggle()
                                case .success(let message):
                                    alertMessage = message
                                    showAlert.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    dismiss()
                                }
                            }
                        }
                    } label: {
                        VStack(spacing: 2) {
                            Image("save_dot")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 55)
                            
                            Text("Yes!")
                                .font(.callout)
                                .fontWeight(.thin)
                                .foregroundColor(.white)
                        }
                        
                        
                    }
                   
                


            }
            .padding(.horizontal, 20)
            .alert(isPresented: $showAlert) {
                return Alert(title: Text(alertMessage))
            }
            
            Spacer()
            
            Button {
                //
                dismiss()
            } label: {
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .opacity(0.5)
            }
        }
        .background(
            ZStack {
                LinearGradient(gradient: Gradient(stops: [
                Gradient.Stop(color: .black, location: 0.50),
                Gradient.Stop(color: .cx_blue, location: 4.0),
                ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("seal")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .opacity(0.2)
                    }
                    .padding(.horizontal, 20)
                }
            }
        )
        //End of body
    }
    fileprivate func joinWorld() {
        
    }
}

struct WorldInviteView_Previews: PreviewProvider {
  
    static var previews: some View {
        
        let data: [String: Any] = [
            WorldField.id: "abc123",
            WorldField.name: "Scout",
            WorldField.description: "We are a community of explorers who scavenge for cool 💎 gems anywhere. We like to find cool spots and learn why they are special.",
            WorldField.hashtags: "#Scout, #ScoutLife, #GetYoStamp",
            WorldField.imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/Worlds%2FScout%2FScout.png?alt=media&token=d4320920-4644-4d99-8636-a3190378ed50",
                WorldField.coverImageUrl: "https://www.womenontopp.com/wp-content/uploads/2019/09/pexels-inga-seliverstova-3394225.jpg",
            WorldField.membersCount: 123,
            WorldField.spotCount: 99,
            WorldField.initiationFee: 0,
            WorldField.monthlyFee: 0,
            WorldField.dateCreated : Date(),
            WorldField.ownerId: "skfhfif",
            WorldField.isPublic: true,
            WorldField.ownerEmail: "James@cityXcape.com",
            WorldField.ownerName: "Cinquain",
            WorldField.ownerImageUrl: ""
        ]
   
        let world = World(data: data)
        WorldInviteView(world: world)
    }
}
