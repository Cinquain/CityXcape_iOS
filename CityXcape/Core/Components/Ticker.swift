//
//  Ticker.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

struct Ticker: View {
    
    @State private var selection: Int = 2
    @State private var refresh: Bool = false
    var profileUrl: String
    @Binding var captions: [String] {
        willSet {
            refresh.toggle()
        }
    }
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.accent)
                    .frame(width: .infinity, height: 60)
                    .overlay(
                        Text(captions[selection])
                            .fontWeight(.light)
                            .padding(.leading, 10)
                            .animation(.easeOut(duration: 1))
                    )
                
                if selection == 2 {
                    UserDotView(imageUrl: profileUrl ?? "", width: 60, height: 60)
                } else {
                    Circle()
                        .stroke(Color.accent, lineWidth: selection == 2 ? 0 : 1)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(imageLoop())
                                .resizable()
                                .frame(width: 60, height: 60, alignment: .center)
                                .cornerRadius(25)
                                .clipped()
                        )
                        .onTapGesture {
                            print("123")
                        }
                }
                
            }
            .foregroundColor(.accent)
            .animation(.easeIn)
            .padding()
            .onAppear(perform: {
                runAnimation()
            })
            .onDisappear(perform: {
            })
        }
     
    }
  
    fileprivate func imageLoop() -> String {
        
        switch selection {
        case 0:
            return "cx"
        case 1:
            return "pin"
        case 2:
            return "User"
        default:
            return "cx"
        }
        
    }
    fileprivate func runAnimation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            if selection == captions.count - 1 {
                return selection = 0
            }
            selection = selection + 1
        }
        timer.fire()
    }
    
}

struct Ticker_Previews: PreviewProvider {
    
    @State static var captions =  [
        "Welcome to CityXcape",
        "Find Secret Spots",
        "Keep Exploring!"
    ]
    

    static var previews: some View {
     
        Ticker(profileUrl: "", captions: $captions)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
