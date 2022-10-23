//
//  WorldInvitationView.swift
//  CityXcape
//
//  Created by James Allan on 10/18/22.
//

import SwiftUI
import Shimmer

struct WorldInvitationView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var vm: WorldViewModel
    @State var currentWorld: World?
    var width: CGFloat = UIScreen.screenWidth
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "envelope.open")
                    .font(.title)

                Text("World Invitations")
                    .font(.title)
                    .fontWeight(.thin)
                Spacer()
            }
            .padding(.horizontal, 20)
            .foregroundColor(.white)
            
            ScrollView {
                Button {
                    currentWorld = vm.worldInvite
                } label: {
                    Image("letter")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Text(vm.worldInvite?.name ?? "")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .offset(y: 15)
                        }
                        .padding(.horizontal, 10)
                }
                .sheet(item: $currentWorld) { world in
                    WorldInviteView(world: world)
                }
            }
            
            Spacer()
            
            Button {
                //
                self.presentationMode.wrappedValue.dismiss()
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
                Color.black.edgesIgnoringSafeArea(.all)
                Image("colored-grid")
                    .scaledToFit()
                    .frame(height: UIScreen.screenHeight)
                    .opacity(0.3)
                    .clipped()
                    .shimmering(active: true, duration: 5, bounce: true)
            }
        )
    }
}

struct WorldInvitationView_Previews: PreviewProvider {
    static var previews: some View {
        WorldInvitationView(vm: WorldViewModel())
    }
}
