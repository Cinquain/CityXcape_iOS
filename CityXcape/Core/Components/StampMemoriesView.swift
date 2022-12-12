//
//  StampMemoriesView.swift
//  CityXcape
//
//  Created by James Allan on 11/30/22.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct StampMemoriesView: View {
    @Environment(\.presentationMode) var presentationMode

    let stamp: Verification
    let width: CGFloat = UIScreen.screenWidth
    @State private var currentIndex: Int = 0
    @State private var showImage: Bool = false
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 120))
    ]
    var body: some View {
        VStack {
            HStack {
                Image(Labels.stamp.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .sheet(isPresented: $showImage) {
                        VStack {
                            WebImage(url: URL(string: stamp.imageCollection[currentIndex]))
                                .resizable()
                            .scaledToFit()
                            
                            Spacer()

                            Image(Labels.stamp.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: width - 100)
                                .overlay {
                                    Text(stamp.name)
                                        .font(.title)
                                        .fontWeight(.light)
                                        .foregroundColor(.stamp_red)
                                        .rotationEffect(Angle(degrees: -30))
                                }
                        }
                        .background(Color.black.edgesIgnoringSafeArea(.all))

                    }
                
                Text(getTitle())
                    .font(.title)
                    .fontWeight(.thin)
                    .foregroundColor(.black)
                
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.diamond.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }

            }
            .padding(.horizontal, 20)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(stamp.imageCollection, id: \.self) { url in
                        Button {
                            currentIndex = stamp.imageCollection.firstIndex(where: {$0 == url}) ?? 0
                            showImage.toggle()
                        } label: {
                            WebImage(url: URL(string: url))
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
            }
            
            
        }
        .background(Color.cx_cream
            .edgesIgnoringSafeArea(.all))
    }
    
    fileprivate func getTitle() -> String {
        if stamp.checkinCount > 1 {
            return "\(stamp.checkinCount) Checkins at \n\(stamp.name)"
        } else {
            return "\(stamp.checkinCount) Checkin at \n\(stamp.name)"
        }
    }
    
}



struct StampMemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        StampMemoriesView(stamp: Verification.demo)
    }
}
