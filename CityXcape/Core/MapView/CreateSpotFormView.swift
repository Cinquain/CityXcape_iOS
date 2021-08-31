//
//  CreateSpotFormView.swift
//  CityXcape
//
//  Created by James Allan on 8/30/21.
//

import SwiftUI
import CoreLocation

struct CreateSpotFormView: View {
    
    
    @State private var spotName: String = ""
    @State private var description: String = ""
    @State private var showPicker: Bool = false
    @State private var addedImage: Bool = false
    @State private var opacity: Double = 0
   
    @State var selectedImage: UIImage = UIImage()
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var placeHolder: String = "Why is this spot special? Share some history"
    
    @Binding var coordinate: CLLocationCoordinate2D
    @Binding var address: String
    
    var body: some View {
        GeometryReader { geo in
        VStack {
            Text("Create New Spot")
                .fontWeight(.semibold)
                .font(.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
            
            TextField("Secret Spot Name", text: $spotName)
                .padding()
                .background(Color.white)
                .cornerRadius(4)
                .padding(.horizontal, 12)
            
             Spacer()
                .frame(maxHeight: 30)
                
                VStack{
                    
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                    
                    Button(action: {
                        
                        showPicker.toggle()
                        addedImage = true
                        
                    }, label: {
                        HStack {
                            Image(systemName: "camera.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                            Text("Secret Spot Image")
                                .fontWeight(.thin)
                                .foregroundColor(.white)
                        }
                    })
                    
                  
                }
                .frame(width: geo.size.width, height: geo.size.width / 1.5)
                
            
            HStack {
                Image(Icon.pin.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                
                Text(address)
            }
            .foregroundColor(.white)
            .padding()
            
            VStack(spacing: 20) {
                HStack {
                    
                    Image(Icon.history.rawValue)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                    Text("Description")
                        .fontWeight(.light)
                        .lineLimit(6)
                }
                .foregroundColor(.white)
                TextEditor(text: $description)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 100)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(4)

            }
            .padding()
            
           

                
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image(Icon.pin.rawValue)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            Text(isReady() ? "Create Spot" : "Missing Fields")
                                .font(.headline)
                        }
                            .padding()
                            .foregroundColor(isReady() ? .blue : .red )
                            .background(isReady() ? Color.white : Color.gray.opacity(0.5))
                            .cornerRadius(4)
                            .padding()

                    })
                    .animation(.easeOut(duration: 0.5))
   
            
            Spacer()
            
    
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showPicker, content: {
            ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
                .colorScheme(.dark)
        })
        }
    }
    
    fileprivate func isReady() -> Bool {
        
        if spotName.count > 3 && addedImage == true && description.count > 10 {
            return true
        } else {
            return false
        }
    }
    
}

struct CreateSpotFormView_Previews: PreviewProvider {
     @State static var address: String = "1229 Spann Ave, Indianapolis, IN, 46203"
     @State static var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 39.75879282513146, longitude: -86.1373309437772)
    
    static var previews: some View {
        CreateSpotFormView(coordinate: $coordinate, address: $address)
    }
    
}
