//
//  LaunchView.swift
//  CityXcape
//
//  Created by James Allan on 4/23/22.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your city...".map({String($0)})
    @State private var showLoadingText: Bool = false
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @State private var scale: Int = 1
    @Binding var showLaunchView: Bool
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    
    var body: some View {
        
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                VStack {
                    Image("fire")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .offset(y: loops % 2 == 0 ? -10 : 0)
                    
                    if showLoadingText {
                        HStack(spacing: 0) {
                            ForEach(loadingText.indices) { index in
                                Text(loadingText[index])
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(.cx_orange)
                                    .offset(y: counter == index ? -5 : 0)
                            }
                        }
                        .transition(AnyTransition.scale.animation(.easeIn))
                    }
                  
                }
                Spacer()
            }
            
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                if loops > 3 {
                    showLaunchView = false
                }
                
                if counter == loadingText.count - 1 {
                    counter = 0
                    loops += 1
                }
                counter += 1
                
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
