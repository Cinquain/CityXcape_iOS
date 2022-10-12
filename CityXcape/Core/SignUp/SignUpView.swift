//
//  SignUpView.swift
//  CityXcape
//
//  Created by James Allan on 8/21/21.
//

import SwiftUI

struct SignUpView: View {
    
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
               
                    
               
                    Button(action: {
                        showSignUp.toggle()
                    }, label: {
                        Text("Start Saving Places")
                            .fontWeight(.light)
                            .font(.subheadline)
                            .frame(width: 210, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                   .stroke(Color.white, lineWidth: 1)
                                   )

                    })
                    .padding(.top, 50)
                
                    Spacer()
                }
                
                
            }
       
     
        }
        .fullScreenCover(isPresented: $showSignUp, content: {
            OnboardingView()
        })
       
    }
    
   
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
