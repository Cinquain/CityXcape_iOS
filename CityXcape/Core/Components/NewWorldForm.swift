//
//  NewWorldForm.swift
//  CityXcape
//
//  Created by James Allan on 9/8/22.
//

import SwiftUI

struct NewWorldForm: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var worldName: String = ""
    @State private var worldDescription: String = ""
    @State private var hashtags: String = ""
    @State private var showPicker: Bool = false
    @State private var image: UIImage?
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var price: Int = 0
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                
                Section("General") {
                    TextField("World Name", text: $worldName)
                        .frame(height: 40)
                    
                    TextField("Describe the spots this world looks for", text: $worldDescription)
                        .frame(height: 40)
                }
                
                Section("#Hashtags") {
                    TextField("Hashtags that belongs to that world", text: $hashtags, onCommit: {
                        converToHashTag()
                    })
                        .frame(height: 40)
                }
                
                Section("Upload Logo (Transparent Background Only)") {
                    Button {
                        showPicker.toggle()
                    } label: {
                        ZStack {
                            
                            if let logo = image {
                                VStack {
                                    Image(uiImage: logo)
                                        .renderingMode(.template)
                                        .resizable()
                                        .foregroundColor(.gray)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: UIScreen.screenWidth)
                                }
                            } else {
                                Image("world_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: .infinity)
                                    .cornerRadius(12)
                            }
                            
                            ProgressView()
                                .opacity(isLoading ? 1 : 0)
                                .scaleEffect(3)
                           
                        }
                        
                        //Label
                    }
                    .listRowInsets(EdgeInsets())
                }
                .sheet(isPresented: $showPicker) {
                    ImagePicker(imageSelected: $image, sourceType: $sourceType)
                        .colorScheme(.dark)
                }
                
                
                Section(header: Text("\(price) Streetcred to join")) {
                    
                    Stepper("Initiation Fee", value: $price, in: 0...100)
             
                }
                
                Section("Finish") {
                    Button {
                        submitWorld()
                    } label: {
                        HStack{
                            Spacer()
                            Text("Create World")
                                .font(.headline)
                            Spacer()
                        }
                        .foregroundColor(.cx_blue)
                    }
                    .listRowInsets(EdgeInsets())

                }

            }
            .navigationBarTitle("Create World", displayMode: .inline)
            .navigationBarItems(trailing: closeButton)


        }
        .colorScheme(.dark)
    }
    
    fileprivate func submitWorld() {
        isLoading = true
        guard let image = image else {
            alertMessage = "Please add a logo for your world"
            showAlert.toggle()
            isLoading = false
            return
        }
        DataService.instance.createWorld(name: worldName, details: worldDescription, hashtags: hashtags, image: image, price: price) { result in
            
            switch result {
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert.toggle()
                    isLoading = false
                case .success(let message):
                    isLoading = false
                    alertMessage = message
                    showAlert.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
    
    func converToHashTag() {
        
        var newWords = [String]()
        let wordsArray = hashtags.components(separatedBy:" ")
            
        
        for word in wordsArray {
            if word.count > 0 {
                
                if word.contains("#") {
                    let newWord = word.replacingOccurrences(of: "#", with: "")
                                    
                    newWords.append("#\(newWord.capitalizingFirstLetter())")
                } else {
                    let newWord = "#\(word.capitalizingFirstLetter())"
                    newWords.append(newWord)
                }
            }
        }
        
        hashtags = ""
        var count = 1
        for word in newWords {
            if count == 4 {
                break
            }
            hashtags += " \(word)"
            count += 1
            
        }
    }
}

extension NewWorldForm {
    
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark.seal")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: 25)
        })
    }
}

struct NewWorldForm_Previews: PreviewProvider {
    static var previews: some View {
        NewWorldForm()
    }
}
