//
//  SpotDetailsView.swift
//  CityXcape
//
//  Created by James Allan on 8/20/21.
//

import SwiftUI

struct SpotDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var passed: Bool = false
    var captions: [String] = [String]()
    var spot: SecretSpot?
    
    init(spot: SecretSpot) {
        self.spot = spot
        let name = spot.name
        let distance = spot.distance < 1 ? "\(spot.distance) mile away" : "\(spot.distance) miles away"
        let postedby = "Posted by \(spot.username)"
        
        self.captions.append(name)
        self.captions.append(distance)
        self.captions.append(postedby)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    Ticker(captions: captions)
                        .frame(height: 120)
                    
                    Image(spot?.imageUrl ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, height: geo.size.height / 2)
                        .cornerRadius(12)
                    
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.")
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .padding()
                    
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image("pin_blue")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            Text(spot?.address ?? "")
                        }
                    })
                    .padding(.leading, 20)
                    
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            passed.toggle()
                        }, label: {
                            VStack {
                                Image(Icon.pass.rawValue)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Delete")
                                    .font(.caption)
                            }
                           
                        })
                        .padding(.trailing, 50)
                    
                    }
                    
                }
                .foregroundColor(.accent)
                
            }
            .alert(isPresented: $passed, content: {
                Alert(title: Text("Delete \(spot?.name ?? "")"),
                      message: Text("Are you sure you want to delete this spot"),
                      primaryButton: .default(Text("Yes"), action: {
                        presentationMode.wrappedValue.dismiss()
                      }), secondaryButton: .cancel())
            })
            .colorScheme(.dark)
        }
       
    }
    
  
    
}

struct SpotDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let spot = SecretSpot(username: "Cinquain", name: "The Big Duck", imageUrl: "donut", distance: 0.5, address: "3402 avenue I, Brooklyn, NY")
        
        SpotDetailsView(spot: spot)
    }
}
