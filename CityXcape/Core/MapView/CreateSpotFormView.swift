//
//  CreateSpotFormView.swift
//  CityXcape
//
//  Created by James Allan on 8/30/21.
//

import SwiftUI
import CoreLocation

struct CreateSpotFormView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    
    @State private var spotName: String = ""
    @State private var description: String = ""
    @State private var showPicker: Bool = false
    @State private var addedImage: Bool = false
    @Binding var opacity: Double
    @State private var presentCompletion: Bool = false
    @State private var showAlert: Bool = false
    @State var selectedImage: UIImage = UIImage()
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var placeHolder: String = "Why is this spot special? Share some history"
    
    @Binding var coordinate: CLLocationCoordinate2D
    @Binding var address: String
    
    var body: some View {
        GeometryReader { geo in
        VStack {
            Text("Create New Spot")
                .font(.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            
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
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
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
                        postSecretSpot()
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
                    .disabled(!isReady())

   
            
            Spacer()
            
    
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showPicker, content: {
            ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
                .colorScheme(.dark)
        })
        .fullScreenCover(isPresented: $presentCompletion, onDismiss: {
            
            NotificationCenter.default.post(name: spotCompleteNotification, object: nil)
            opacity = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }, content: {
            CongratsView()
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Error posting Secret Spot 😤"))
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
    
    fileprivate func postSecretSpot() {
        guard let userId = userId else {return}

        DataService.instance.uploadSecretSpot(spotName: spotName, address: address, image: selectedImage, coordinates: coordinate, uid: userId) { (success) in
            
            if success {
                presentCompletion.toggle()
            } else {
                showAlert.toggle()
            }
        }
    }
    
}

struct CreateSpotFormView_Previews: PreviewProvider {
     @State static var address: String = "1229 Spann Ave, Indianapolis, IN, 46203"
     @State static var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 39.75879282513146, longitude: -86.1373309437772)
    
    static var previews: some View {

        CreateSpotFormView(opacity: .constant(0), coordinate: $coordinate, address: $address)
    }
    
}
