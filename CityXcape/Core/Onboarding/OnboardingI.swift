//
//  OnboardingI.swift
//  CityXcape
//
//  Created by James Allan on 9/13/22.
//

import SwiftUI
import Shimmer

struct OnboardingI: View {
    let width: CGFloat = UIScreen.screenWidth
    @State private var didLike: Bool = false
    
    var body: some View {
        VStack {
            
            Image("magic garden")
                .resizable()
                .scaledToFit()
                .frame(width: width + 20)
                .overlay {
                    VStack {
                    
                        Spacer()
                        HStack {
                            Image(Icon.pin.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Text("Graffiti Pier")
                                .font(.title3)
                                .foregroundColor(.white)
                                .fontWeight(.thin)
                            
                            Spacer()
                            
                            Image(Icon.dot.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            
                            Text("0.5 Miles")
                                .font(.caption)
                                .foregroundColor(.white)
                                .fontWeight(.thin)

                        }
                        .padding(.horizontal, 10)
                    }
                    .background(
                        LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
                    )
                    
                }
            
            HStack {
                Spacer()
                Text("Start by Saving a Location")
                    .font(.title2)
                    .fontWeight(.thin)
                Spacer()
            }
            .foregroundColor(.white)
            
            HStack(alignment: .center) {
                
                VStack {
                    
                    Image(Icon.x.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    Text("pass")
                        .fontWeight(.thin)
                        .foregroundColor(.red)
                }
                
                Spacer()
                    .frame(width: 50)
                
                VStack {
                    Image(Icon.heart.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    Text("save")
                        .fontWeight(.thin)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            didLike = true
        }
    }
}

struct OnboardingI_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingI()
    }
}
