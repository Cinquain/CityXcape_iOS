//
//  SignUpView.swift
//  CityXcape
//
//  Created by James Allan on 8/21/21.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var showOnboarding: Bool = false
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
                    Text("Find Secret Spots")
                        .font(.title3)
                        .fontWeight(.thin)
                        .foregroundColor(.accent)
                    
               
                    Button(action: {
                        showOnboarding.toggle()
                    }, label: {
                        Text("Login / Signup")
                            .standardButtonFormatting(textColor: .black, color: .white)

                    })
                    .padding(.top, 50)
                
                    Spacer()
                }
               
                
                
            }
       
            Image(Icon.compass.rawValue)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.white)
                .frame(width: 300, height: 300)
                .opacity(0.07)
        }
        .fullScreenCover(isPresented: $showOnboarding, content: {
            OnboardingView()
        })
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
