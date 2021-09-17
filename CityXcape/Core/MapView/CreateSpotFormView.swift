//
//  CreateSpotFormView.swift
//  CityXcape
//
//  Created by James Allan on 8/30/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct CreateSpotFormView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var spotName: String = ""
    @State private var description: String = ""
    @State private var world: String = ""
    @State private var showPicker: Bool = false
    @State private var addedImage: Bool = false
    @State private var presentPopover: Bool = false
    @Binding var opacity: Double
    @State private var presentCompletion: Bool = false
    @State private var showAlert: Bool = false
    @State var selectedImage: UIImage = UIImage()
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var placeHolder: String = "Why is this spot special? Share some history"
    
    var mapItem: MKMapItem
    
    var body: some View {
        
            GeometryReader { geo in
                VStack {
                    Text("Post New Spot")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    
                    TextField("Secret Spot Name", text: $spotName)
                        .padding()
                        .background(Color.white)
                        .accentColor(.black)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                        .padding(.horizontal, 12)
                    
                     Spacer()
                        .frame(maxHeight: 30)
                    
                    VStack(spacing: 10) {
                        HStack {
                            
                            Image(Icon.history.rawValue)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 25, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                            Text("Description")
                                .fontWeight(.light)
                                .lineLimit(6)
        
                        }
                        .foregroundColor(.white)
                        TextEditor(text: $description)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .multilineTextAlignment(.leading)
                            .background(Color.white)
                            .cornerRadius(4)
                    }
                    .padding()
                    
                    HStack {
                        Button(action: {
                            presentPopover.toggle()
                        }, label: {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.yellow)
                                .font(.largeTitle)
                        })
                        
                        TextField("World Name", text: $world) {
                           converToHashTag()
                        }
                        .padding()
                        .background(Color.white)
                        .accentColor(.black)
                        .foregroundColor(.black)
                        .frame(maxWidth: geo.size.width / 2)
                    }
                    .padding(.bottom, 10)
                    
                        
                        VStack{
                            
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
                            
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(12)
                            
                        }
                        .frame(width: geo.size.width, height: geo.size.width / 1.5)
                        
                    
                    HStack {
                        Image(Icon.pin.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        
                        Text(mapItem.getAddress())
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                    .foregroundColor(.white)
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

                    
            
                }
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
                .popover(isPresented: $presentPopover, content: {
                    Text("Different World Different Spots")
                })
                        
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))


    
    }
    
    fileprivate func isReady() -> Bool {
        
        if spotName.count > 4
            && addedImage == true
            && description.count > 10
            && world.count > 4 {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func postSecretSpot() {

        DataService.instance.uploadSecretSpot(spotName: spotName, description: description, image: selectedImage, world: world, mapItem: mapItem) { (success) in
            
            if success {
                presentCompletion.toggle()
            } else {
                showAlert.toggle()
            }
        }
    }
    
    fileprivate func converToHashTag() {
        var newWords = [String]()
        let wordsArray = world.components(separatedBy:" ")
        for word in wordsArray {
            if word.count > 0 {
                let newWord = "#\(word.lowercased())"
                newWords.append(newWord)
                print(newWord)
            }
        }
        world = newWords.joined(separator:" ")
    }
    
}

struct CreateSpotFormView_Previews: PreviewProvider {
     @State static var address: String = "1229 Spann Ave, Indianapolis, IN, 46203"
     @State static var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 39.75879282513146, longitude: -86.1373309437772)
    
    static var previews: some View {

        CreateSpotFormView(opacity: .constant(0), mapItem: MKMapItem())
    }
    
}
