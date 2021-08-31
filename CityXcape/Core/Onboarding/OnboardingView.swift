//
//  OnboardingView.swift
//  CityXcape
//
//  Created by James Allan on 8/21/21.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var showOnboarding: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    @State var email: String = ""
    @State var name: String = ""
    @State var providerId: String = ""
    @State var provider: String = ""
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                    .frame(height: geo.size.width / 3)
            
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Image("fire")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: geo.size.height / 3)
                        Spacer()
                    }
                    Text("  CityXcape")
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .opacity(1)
                }
              
                Spacer()
                    .frame(height: 40)
                Button(action: {
                    showOnboarding.toggle()
                }, label: {
                    SignInWithAppleButton()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                })
                
                Button(action: {
                    showOnboarding.toggle()
                }, label: {
                    HStack {
                        Image(Icon.globe.rawValue)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Sign in with Google")
                            .font(.title2)
                    }
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(8)
                    
                })
                Spacer()
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(Icon.back.rawValue)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding()
                    })
                   
                    Spacer()
                }
                .padding()
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $showOnboarding, content: {
                OnboardingViewII(email: $email, name: $name, providerId: $providerId, provider: $provider)
            })
            
        }
     
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
