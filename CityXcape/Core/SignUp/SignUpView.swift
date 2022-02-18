//
//  SignUpView.swift
//  CityXcape
//
//  Created by James Allan on 8/21/21.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var showOnboarding: Bool = false
    @State private var showSignUp: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AnimationView()
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.size.height / 3)
                    Image(Icon.logo.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width - 50)
                        .padding()
                    Text("Save Places to Visit")
                        .font(.title3)
                        .fontWeight(.thin)
                        .foregroundColor(.accent)
                    
               
                    Button(action: {
                        showSignUp.toggle()
                    }, label: {
                        Text("Login / Signup")
                            .standardButtonFormatting(textColor: .black, color: .white)

                    })
                    .padding(.top, 50)
                
                    Spacer()
                }.onAppear(perform: {
                    checkOnboarding()
                })
               
                
                
            }
       
            Image(Icon.compass.rawValue)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.white)
                .frame(width: 300, height: 300)
                .opacity(0.07)
        }
        .fullScreenCover(isPresented: $showSignUp, content: {
            OnboardingView()
        })
        .fullScreenCover(isPresented: $showOnboarding, content: {
            OnboardScreen()
        })
        
    }
    
    fileprivate func checkOnboarding() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.setValue(true, forKey: "didLaunchBefore")
            print("did not launch app before")
            DispatchQueue.main.async {
                self.showOnboarding.toggle()
            }
        } else {
            print("Did launch app before")
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
