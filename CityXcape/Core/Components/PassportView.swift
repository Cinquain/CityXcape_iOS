//
//  PassportView.swift
//  CityXcape
//
//  Created by James Allan on 3/1/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct PassportView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var verification: Verification
    var width: CGFloat = UIScreen.screenWidth
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: 10) {
                ZStack {
                    Color.white
                    
                    WebImage(url: URL(string: verification.imageUrl))
                        .resizable()
                        .frame(width: width - 40, height: width - 40)
                }
                .frame(width: width - 20, height: width - 20)
                
                HStack {
                    Spacer()
                    Image("pin_blue")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(.bottom, 12)
                    Text(verification.name)
                        .font(Font.custom("Savoye LET", size: 42))
                        .fontWeight(.thin)
                        .foregroundColor(.black)
                    Spacer()
                }
        

                
            }
            
            VStack(spacing: 0) {
                HStack {
                    Text("Your Reaction")
                        .font(Font.custom("Savoye LET", size: 35))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                HStack {
                    Text(verification.comment)
                        .font(Font.custom("Savoye LET", size: 25))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)

            }
        
            Spacer()

            HStack {
                Spacer()
                Image("Stamp")
                    .resizable()
                    .scaledToFit()
                    .frame(height: width - 100 )
                    .overlay(
                        VStack(alignment: .center, spacing: 0) {
                            
                            
                            Text(verification.time.formattedDate())
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.stamp_red)
                            
                            Text("\(verification.name), \(verification.time.timeFormatter())")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.stamp_red)
                            
                        
                        }
                        .rotationEffect(Angle(degrees: -30))
                        )
            }
            .padding()
            
            
            Button {
                //
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .opacity(0.5)
            }
      
            
        }
        .background(Color.cx_cream.edgesIgnoringSafeArea(.all))
    }
}

struct PassportView_Previews: PreviewProvider {
    static var previews: some View {
        
        
    let data: [String: Any] = [
        "comment": "Wow, what an amazing spot",
        "imageUrl":"https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2Fw3QA4EFQ1j0yJeCSWyww%2F1?alt=media&token=22fd7993-9352-4798-851a-18fa0a60800b",
        "verifierId": "abc123",
        "spotOwnerId": "xyzabc",
        "city": "New York",
        "country": "United States",
        "time": FieldValue.serverTimestamp(),
        "latitude": 10110,
        "longitude": 304004,
        "name": "Pier 24",
        "postId": "ahfigoshg"
    ]
        let verification = Verification(data: data)
        
        PassportView(verification: verification)
    }
}
