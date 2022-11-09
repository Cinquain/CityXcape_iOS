//
//  DiscoverWorlds.swift
//  CityXcape
//
//  Created by James Allan on 9/11/22.
//

import SwiftUI
import Shimmer

struct DiscoverWorlds: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var vm: WorldViewModel
    @State var currentWorld: World?
  
    var body: some View {
        
        VStack {
            HStack {
                Image("grid")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                Text("Find Your World")
                    .font(.title)
                    .fontWeight(.thin)
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            
            ScrollView {
                
                ForEach(vm.worlds) { world in
                    
                    Button {
                        if vm.isValid(world: world) {
                            currentWorld = world
                        }
                    } label: {
                        WorldThumb(world: world)
                    }
                    .sheet(item: $currentWorld) { world in
                        WorldInviteView(world: world)
                    }

                }
                
            }
            
            Button {
                vm.showWorldForm.toggle()
            } label: {
                VStack {
                    Image(systemName: "globe")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 35)
                        .opacity(0.5)
                    Text("Create World")
                        .fontWeight(.thin)
                }
                .background(Color.black)
                .frame(width: UIScreen.screenWidth / 2, height: 100)
                .cornerRadius(25)
            }
            .sheet(isPresented: $vm.showWorldForm) {
                NewWorldForm()
            }

            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .opacity(0.5)
            }
            .alert(isPresented: $vm.showAlert) {
                return Alert(title: Text(vm.alertMessage))
            }

            
            Spacer()
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
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct DiscoverWorlds_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverWorlds(vm: WorldViewModel())
    }
}
