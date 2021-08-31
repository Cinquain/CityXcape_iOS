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
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.size.height / 3)
                    Image(Icon.logo.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width - 50)
                        .padding()
                    Text("Save Your Secret Spots in One Place")
                        .font(.title3)
                        .fontWeight(.thin)
                        .foregroundColor(.accent)
                    
               
                    Button(action: {
                        showOnboarding.toggle()
                    }, label: {
                        Text("Login / Signup")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .white, radius: 2, x: 0, y: 0)

                    })
                    .padding(.top, 50)
                
                    Spacer()
                }
                .background(Color.background)
                .edgesIgnoringSafeArea(.all)
                
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
