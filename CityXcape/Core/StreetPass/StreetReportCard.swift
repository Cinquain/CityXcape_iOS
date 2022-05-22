//
//  StreetReportCard.swift
//  CityXcape
//
//  Created by James Allan on 3/19/22.
//

import SwiftUI

struct StreetReportCard: View {
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    
    @StateObject var vm: AnalyticsViewModel = AnalyticsViewModel()
    @State private var showTotalView: Bool = false
    @State private var currentType: AnalyticsType?
    
    var body: some View {
        
        VStack {
            
            HStack {
             
                
                VStack(spacing: 0) {
                  
                    
                    Text("Street Report Card")
                        .font(Font.custom("Lato", size: 35))
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                    
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            
       
            
            
            
            HStack {
                
                VStack(alignment: .center) {
                    UserDotView(imageUrl: profileUrl ?? "", width: 80)
                    Text(displayName ?? "")
                        .font(.caption)
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                        .frame(width: 80)
                    
                }
                .padding(.leading, 20)


                
                Button {
                        vm.showRanks.toggle()
                    } label: {
                        VStack {
                            Text("Current Rank: \(vm.rank)")
                                .foregroundColor(.white)
                            BarView(progress: vm.progressValue)
                            Text(vm.progressString)
                                .font(.caption)
                                .fontWeight(.thin)

                        }

                    }
                    .padding(.leading, 30)
                    .sheet(isPresented: $vm.showRanks) {
                        Ranks()
                }
                
                Spacer()
            }
            .padding(.top, 20)


            VStack(alignment: .leading) {
                HStack {
                    
                    Button {
                        //TBD
                        vm.showLeaderboard.toggle()
                    } label: {
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Image("leaderboard")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.cx_orange)
                                .scaledToFit()
                            .frame(height: 30)
                            
                            Text("Leaderboard")
                                .foregroundColor(.cx_orange)
                                .font(.title3)
                                .fontWeight(.thin)
                            Spacer()
                        }
                        
                   
                    }
                    .sheet(isPresented: $vm.showLeaderboard) {
                        Leaderboard(ranks: vm.ranking)
                    }
                    
                    
                    Spacer()
                }
                
            
                
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
       

            Spacer()
            
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
               
                //Button 1
                
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
                .padding()
                .fullScreenCover(item: $currentType, content: { type in
                    TotalView(type: type, spots: vm.ownerSpots)
                })
               
                //Button 1
                
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
                
                
                //Button 1

                
                
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
        StreetReportCard()
    }
}
