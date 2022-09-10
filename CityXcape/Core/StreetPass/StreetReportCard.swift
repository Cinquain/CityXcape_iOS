//
//  StreetReportCard.swift
//  CityXcape
//
//  Created by James Allan on 3/19/22.
//

import SwiftUI
import SwiftPieChart

struct StreetReportCard: View {
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    
    @StateObject var vm: AnalyticsViewModel = AnalyticsViewModel()
    @StateObject var streetPass: StreetPassViewModel
    @State private var showTotalView: Bool = false
    @State private var currentType: AnalyticsType?
    
    var body: some View {
        
        VStack {
            
       
            
            
            
            HStack {
                
                VStack(alignment: .center) {
                    UserDotView(imageUrl: profileUrl ?? "", width: 80)
                    Text(displayName ?? "")
                        .font(.caption)
                        .fontWeight(.thin)
                        .frame(width: 80)
                    
                }

                Text("Your top community is: \(vm.topWorld)")
                    .font(.title3)
                    .fontWeight(.thin)
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            HStack {
                
                Button {
                    //TBD
                    vm.showWorld.toggle()
                } label: {
                    VStack {
                        Image("world")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                        Text("Create a World")
                            .fontWeight(.thin)
                    }
                }

             
            }
            .foregroundColor(.white)
            .padding(.top, 20)
            .sheet(isPresented: $vm.showWorld) {
                NewWorldForm()
            }


            
            HStack {
                Image("graph")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                
                Text("Analytics")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                
            }
            .padding(.top, 50)
            
            VStack {
                
                Button {
                    //TBD
                    currentType = .views
                    showTotalView.toggle()
                } label: {
                    HStack {
                        Text("\(vm.totalSpotsPosted) Spots")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        Spacer()
                        Image("pin_blue")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .foregroundColor(.white)
                        
                    }
                    .frame(width: 180)

                }
                .fullScreenCover(item: $currentType, content: { type in
                    TotalView(type: type, spots: vm.ownerSpots.sorted(by: {$0.viewCount > $1.viewCount}))
                })
               
                //Button 2
                
                Button {
                    //TBD
                    currentType = .saves
                    showTotalView.toggle()
                } label: {
                    HStack {
                        Text("\(vm.totalSaves) Saves")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        Spacer()
                        Image("dot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.white)
                        
                    }
                    .frame(width: 180)

                }
                .fullScreenCover(item: $currentType, content: { type in
                    TotalView(type: type, spots: vm.ownerSpots)
                })
               
                //Button 3
                
                Button {
                    //TBD
                    currentType = .checkins
                    showTotalView.toggle()
                } label: {
                    HStack {
                        Text("\(vm.totalVerifications) Checkins")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        Spacer()
                        Image("checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.white)
                        
                    }
                    .frame(width: 180)
                }
                .fullScreenCover(item: $currentType, content: { type in
                    TotalView(type: type, spots: vm.ownerSpots)
                })
                
                
                //Button 4
                
                Button {
                    //TB
                    AnalyticsService.instance.checkedStreetFollowers()
                    vm.showStreetFollowers.toggle()
                } label: {
                    HStack {
                       
                            
                        Text("\(vm.streetFollowers.count) Followers")
                         .font(.title3)
                         .fontWeight(.thin)
                         .foregroundColor(.white)
                         .padding(.trailing, 20)
                        
                        Spacer()
                        
                        Image("running")
                             .resizable()
                             .scaledToFit()
                             .frame(height: 30)
                             .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))


                    }
                    .frame(width: 180)
                
                }
                .fullScreenCover(isPresented: $vm.showStreetFollowers) {
                    StreetFollowersView(vm: vm)
                }
        
   
                
            }
            .padding(.top, 20)
            
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
        .background(LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: .black, location: 0.40),
            Gradient.Stop(color: .cx_orange, location: 3.0),
        ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

struct StreetReportCard_Previews: PreviewProvider {
    static var previews: some View {
        StreetReportCard(streetPass: StreetPassViewModel())
    }
}
