//
//  CreateSpotFormView.swift
//  CityXcape
//
//  Created by James Allan on 8/30/21.
//

import SwiftUI
import MapKit
import CoreLocation
import JGProgressHUD_SwiftUI

struct CreateSpotFormView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator


    @Binding var selectedTab: Int

    @State private var spotName: String = ""
    @State private var description: String = ""
    @State private var world: String = ""
    
    @State private var showPicker: Bool = false
    @State private var addedImage: Bool = false
    @State private var isPublic: Bool = true
    @State private var alertMessage: String = ""
    @State private var presentPopover: Bool = false
    @State private var presentCompletion: Bool = false
    @State private var showAlert: Bool = false
    @State private var buttonDisabled: Bool = false
    @State private var showActionSheet: Bool = false
    
    @State var selectedImage: UIImage = UIImage()
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    var mapItem: MKMapItem
    
    var body: some View {
        
            GeometryReader { geo in
                VStack {
                    Text("Post Spot")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    
                    TextField("Secret Spot Name", text: $spotName)
                        .placeholder(when: spotName.isEmpty) {
                            Text("Secret Spot Name").foregroundColor(.gray)
                    }
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
                            .cornerRadius(4)
                            .keyboardType(.alphabet)
                    }
                    .padding()
                    
                    HStack {
                        Button(action: {
                            isPublic.toggle()
                        }, label: {
                            if isPublic {
                                Image("globe")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                            } else {
                                Image(systemName: "lock.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.yellow)
                            }
                         
                        })
                        
                        if isPublic {
                            TextField("What community is this for?", text: $world) {
                               converToHashTag()
                            }
                            .placeholder(when: world.isEmpty) {
                                Text("What community is this for?").foregroundColor(.gray)
                        }
                            .padding()
                            .background(Color.white)
                            .accentColor(.black)
                            .foregroundColor(.black)
                            .frame(maxWidth: geo.size.width / 1.5)
                        } else {
                            Text("Secret Spot is Private")
                                .foregroundColor(.white)
                               
                        }
                        
                    }
                    .padding(.bottom, 10)
                    
                        
                        VStack{
                            
                            Button(action: {
                                showActionSheet.toggle()
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
                                isReady()
                            }, label: {
                                HStack {
                                    Image(Icon.pin.rawValue)
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    Text("Create Spot")
                                        .font(.headline)
                                }
                                    .padding()
                                    .foregroundColor(.blue)
                                    .background(Color.white)
                                    .cornerRadius(4)
                                    .padding()

                            })
                            .animation(.easeOut(duration: 0.5))
                            .disabled(buttonDisabled)

                    
            
                }
                .sheet(isPresented: $showPicker, onDismiss: {
                    addedImage = true
                }, content: {
                    ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
                        .colorScheme(.dark)
                })
                .fullScreenCover(isPresented: $presentCompletion, onDismiss: {
                    
                    selectedTab = 0
                    NotificationCenter.default.post(name: spotCompleteNotification, object: nil)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, content: {
                    CongratsView()
                    
                })
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text(alertMessage))
                })
                .popover(isPresented: $presentPopover, content: {
                    Text("Different World Different Spots")
                })
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("Source Options"), message: nil, buttons: [
                        .default(Text("Camera"), action: {
                            sourceType = .camera
                            showPicker.toggle()
                        }),
                        .default(Text("Photo Library"), action: {
                            sourceType = .photoLibrary
                            showPicker.toggle()
                        })
                    ])
                    
                }
                        
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))


    
    }
    
    fileprivate func isReady()  {
        
        
        hudCoordinator.showHUD {
            let hud = JGProgressHUD()
            hud.style = .dark
            hud.textLabel.text = "Uploading Secret Spot"
            return hud
        }
    
        if spotName.count > 4
            && addedImage == true
            && description.count > 10
            && world.count > 2
            && isPublic {
            postSecretSpot()
        } else {
            
            if spotName.count < 4 {
                hudCoordinator.presentedHUD?.dismiss()
                alertMessage = "Spot needs a title at least four characters long"
                showAlert.toggle()
                return
            }
            
            if description.count < 10 {
                hudCoordinator.presentedHUD?.dismiss()
                alertMessage = "Description needs to be at least 10 characters long"
                showAlert.toggle()
                return
            }
            
            if world.count < 3 {
                hudCoordinator.presentedHUD?.dismiss()
                alertMessage = "Please include a World. \n Your spot can only be visible to a community"
                showAlert.toggle()
                return
            }
            
            if addedImage == false {
                hudCoordinator.presentedHUD?.dismiss()
                alertMessage = "Please add an image for your spot"
                showAlert.toggle()
                return
            }
            
        }
    }
    
    fileprivate func postSecretSpot() {

        buttonDisabled = true

        DataService.instance.uploadSecretSpot(spotName: spotName, description: description, image: selectedImage, world: world, mapItem: mapItem, isPublic: isPublic) { (success) in
            
            if success {
                hudCoordinator.presentedHUD?.dismiss()
                buttonDisabled = false
                presentCompletion.toggle()
            } else {
                hudCoordinator.presentedHUD?.dismiss()
                buttonDisabled = false
                showAlert.toggle()
                alertMessage = "Error posting Secret Spot 😤"
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
    @State static var tabIndex: Int = 1
    static var previews: some View {
        CreateSpotFormView(selectedTab: $tabIndex, mapItem: MKMapItem())
    }
    
}
