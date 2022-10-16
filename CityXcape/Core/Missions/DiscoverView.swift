//
//  MissionsView.swift
//  CityXcape
//
//  Created by James Allan on 10/2/21.
//

import SwiftUI

struct DiscoverView: View {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    

    @State private var isPresented: Bool = false
    @State private var currentSpot: SecretSpot?
    @Binding var selectedTab: Int


    @GestureState private var dragState: DragState = .inactive
    @State private var showMenu: Bool = false
    
    let width =  UIScreen.screenWidth
    var dragThreshold: CGFloat = 65.0
    @StateObject var vm: DiscoverViewModel
    
    var body: some View {
 
        NavigationView {
    
            ZStack(alignment: .top) {
                    
                    if vm.newSecretSpots.isEmpty {
                             VStack {
                                   emptyStateIcon
                                 
                                   refreshButton
                                     
                             }
                                     
                     } else {
                    
                         ZStack {
                             ForEach(vm.cardViews) { cardview in
                               cardview
                                .zIndex(vm.isTopCard(cardView: cardview) ? 1 : 0)
                                .overlay(
                                    ZStack {
                                        VStack {
                                            Image(systemName: "x.circle")
                                                .modifier(swipeModifier())
                                           
                                            Text("dismiss!")
                                                .foregroundColor(.white)
                                                .font(.title2)
                                                .fontWeight(.medium)
                                                .fullScreenCover(isPresented: $vm.showSignUp) {
                                                    OnboardingView()
                                                }
                                        }
                                        .opacity(dragState.translation.width <  -dragThreshold && vm.isTopCard(cardView: cardview) ? 1 :0.0)
                                        
                                        VStack {
                                            Image(systemName: "heart.circle")
                                                .modifier(swipeModifier())
                                           
                                            Text("saved!")
                                                .foregroundColor(.white)
                                                .font(.title2)
                                                .fontWeight(.medium)
                                        }
                                        .opacity(dragState.translation.width >  dragThreshold && vm.isTopCard(cardView: cardview) ? 1 :0.0)
                                    }
                                
                                )
                                .offset(x: vm.isTopCard(cardView: cardview) ? self.dragState.translation.width : 0, y: vm.isTopCard(cardView: cardview) ? self.dragState.translation.height : 0)
                                .scaleEffect(self.dragState.isDragging && vm.isTopCard(cardView: cardview) ? 0.85 : 1)
                                .rotationEffect(Angle(degrees: vm.isTopCard(cardView: cardview) ? Double(self.dragState.translation.width / 12) : 0))
                                .animation(.interpolatingSpring(stiffness: 120, damping: 120))
                                .gesture(LongPressGesture(minimumDuration: 0.01)
                                    .sequenced(before: DragGesture())
                                    .updating(self.$dragState, body: { value, state, transaction in
                                        
                                        switch value {
                                            case .first(true):
                                                state = .pressing
                                            case .second(true, let drag):
                                                state = .dragging(translation: drag?.translation ?? .zero)
                                            default:
                                                break
                                        }
                                    })
                                    .onEnded({ value in
                                        guard case .second(true, let drag?)  = value else {return}
                                        
                                        if drag.translation.width < -self.dragThreshold - 20  {
                                            vm.moveCards(drag.translation.width)
                                        } else if drag.translation.width > self.dragThreshold + 20 {
                                            vm.moveCards(drag.translation.width)
                                        }
                                    })
                                 )
                             }
                         }
                         .padding(.bottom, 30)
                        
                    }

                   //End of Scrollview
                
                VStack {
                    Spacer()
                    HStack(alignment: .center, spacing: 10) {
                        Button {
                            vm.moveCards(-75)
                        } label: {
                            Image("x")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                        }
                        
                        Button {
                            vm.undoMoveCard()
                        } label: {
                            Image("back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                        }
                        
                        
                        Button {
                            vm.moveCards(70)
                        } label: {
                            Image("heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                
                GeometryReader { _ in
                    HStack {
                        SideMenu(selectedTab: $selectedTab, showMenu: $showMenu)
                            .offset(x: showMenu ? 0 : -width - 50)
                            .animation(.easeOut(duration: 0.3), value: showMenu)
                        
                        Spacer()
                    }
                }
                .background(Color.black.opacity(showMenu ? 0.5 : 0))
                .onTapGesture {
                    showMenu.toggle()
                }
                
                //End of ZStack
            }
            .navigationBarItems(leading: sandwichMenu, trailing: searchButton)
            .toolbar {
               ToolbarItem(placement: .principal) {
                   ZStack {
                       
                       Ticker(searchText: $vm.searchTerm, handlesearch: {
                           vm.searchForSpot()
                       }, width: UIScreen.screenWidth, searchTerm: vm.placeHolder)
                       .frame(width: UIScreen.screenWidth / 2 )
                       .opacity(vm.isSearching ? 1 : 0)

                       tabIcon
                           .opacity(vm.isSearching ? 0 : 1)
                   }
                   
               }
            }
       

            
        }
        .colorScheme(.dark)
        .foregroundColor(.white)
        .alert(isPresented: $vm.showAlert) {
            return Alert(title: Text(vm.alertMessage), dismissButton: .default(Text("Ok"), action: {
                if userId == nil {
                    vm.showSignUp = true
                }
            }))
        }
        
    }

}

extension DiscoverView {
    
    private var passAnimation: some View {
        Image(systemName: "hand.thumbsdown.fill")
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .foregroundColor(.stamp_red)
    }
    
    private var searchButton: some View {
        
        Button {
            vm.isSearching.toggle()
        } label: {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
        }
        
    }
    
    
    private var sandwichMenu: some View {
        Button {
            showMenu.toggle()
        } label: {
            Image(systemName: showMenu ? "xmark" :  "text.justify")
                .font(.title3)
                .foregroundColor(.white)
                .animation(.easeOut(duration: 0.3), value: showMenu)
        }
    }
    
    private var refreshButton: some View {
        Button {
            vm.refreshSecretSpots()
            AnalyticsService.instance.loadedNewSpots()
        } label: {
                Text("Refresh")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 120, height: 40)
                    .background(Color.white)
                    .foregroundColor(.cx_blue)
                    .cornerRadius(20)
    }

    }
    
    private var tabIcon: some View {
        VStack(spacing: 0) {
            Image("logo")
                .resizable()
                .scaledToFit()
            .frame(height: 25)
            Text("save places to visit")
                .fontWeight(.thin)
                .foregroundColor(.white)
                .font(.caption)
        }
    }
    
    private var emptyStateIcon: some View {
        VStack {
            Image("404")
                .resizable()
                .scaledToFit()
            .frame(height: 200)
            Text("No Secret Spots Found")
                .font(.title2)
                .fontWeight(.thin)
        }
       
    }
    
    
}


struct MissionsView_Previews: PreviewProvider {
    @State static var selection: Int = 0
    static var previews: some View {
        DiscoverView(selectedTab: .constant(2), vm: DiscoverViewModel())
    }
}
