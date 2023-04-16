//
//  SaveTrailView.swift
//  CityXcape
//
//  Created by James Allan on 4/14/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SaveTrailView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var spots: [SecretSpot] = []
    @State var message: String = ""
    @State var showAlert: Bool = false
    
    var trail: Trail
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack {
                VStack(spacing: 0) {
                    ImageSlider(images: trail.imageUrls)
                        .frame(height: size.height / 3)
                    Text(trail.name)
                        .font(.title2)
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text(message))
                        }
                }
                
                ScrollView {
                    ForEach(spots) { spot in
                        spotItem(spot: spot, stamped: false)
                    }
                }
                .frame(height: size.height / 2)
                
                Spacer(minLength: 30)
                actionButtons()
                
                Spacer()
            }
        }
        .background(.black)
        .onAppear {
            getAllSpots()
        }
    }
    
    @ViewBuilder
    fileprivate func actionButtons() -> some View {
        HStack {
            
            Button {
                dismiss()
            } label: {
                VStack(spacing: 2) {
                    Image("pass_dot")
                        .resizable()
                        .scaledToFit()
                    .frame(height: 55)
                    
                    Text("I'll Pass")
                        .font(.callout)
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            Button {
                saveTrail()
            } label: {
                VStack(spacing: 2) {
                    Image("save_dot")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 55)
                    
                    Text("Save Trail!")
                        .font(.callout)
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                }
            }
        
        }
        .padding(.horizontal, 100)
    }
    
    @ViewBuilder
    fileprivate func spotItem(spot: SecretSpot, stamped: Bool) -> some View {
        HStack(spacing: 80) {
            WebImage(url: URL(string: spot.imageUrls.first ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .cornerRadius(10)
                .overlay {
                    if stamped {
                        Image("Stamp")
                            .resizable()
                            .scaledToFit()
                    }
                }

            
            VStack(alignment: .leading) {
                HStack {
                    Image("pin_blue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                    Text(spot.spotName)
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .lineLimit(1)
                }
                
                Text(spot.description ?? "")
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(width: 300)
            }
            .frame(maxWidth: 200)
        }
    }
    
    func getAllSpots() {
        trail.spots.forEach { spotId in
            DataService.instance.getSpecificSpot(postId: spotId) { result in
                switch result {
                    case .success(let spot):
                        spots.append(spot)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
    
    fileprivate func saveTrail() {
        DataService.instance.saveTrail2UserDB(trail: trail) { result in
            switch result {
            case .failure(let error):
                message = error.localizedDescription
                showAlert.toggle()
            case .success(_):
                message = "Trail Successfully Saved!"
                showAlert.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    dismiss()
                }
            }
        }
    }
}

struct SaveTrailView_Previews: PreviewProvider {
    static var previews: some View {
        SaveTrailView(trail: Trail.demo)
    }
}
