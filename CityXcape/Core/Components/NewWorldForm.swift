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
    @State private var email: String = ""
    @State private var hashtags: String = ""
    @State private var alertMessage: String = ""
    @State private var requirements: String = ""
    @State private var showAlert: Bool = false

    @State private var price: Int = 0
    @State private var spots: Int = 0
    @State private var stamps: Int = 0
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                
                Section("General") {
                    TextField("World Name", text: $worldName)
                        .frame(height: 40)
                    
                    TextField("Describe what this community is about", text: $worldDescription)
                        .frame(height: 40)
                    
                    TextField("What are the requirements to join this community", text: $requirements)
                        .frame(height: 40)
                }
                
                Section("#Hashtags") {
                    TextField("Hashtags that belongs to that world", text: $hashtags, onCommit: {
                        converToHashTag()
                    })
                        .frame(height: 40)
                }
                
                Section("Your Info") {
                    TextField("Your Email", text: $email)
                        .frame(height: 40)
                }
            
                
                
                Section(header: Text("\(price) STC, \(spots) spots, \(stamps) stamps")) {
                    
                    Stepper("Streetcred", value: $price, in: 0...100)
                    Stepper("# of Spots", value: $spots, in: 0...50)
                    Stepper("# of Stamps", value: $stamps, in: 0...50)


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
        .alert(isPresented: $showAlert) {
            return Alert(title: Text(alertMessage))
        }
    }
    
    fileprivate func submitWorld() {
        isLoading = true
        
        DataService.instance.createWorld(name: worldName, details: worldDescription, email: email, req: requirements, reqSpots: spots, reqStamps: stamps, hashtags: hashtags, price: price) { result in
            
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
    
    fileprivate func validateForm()  {
        if !(worldName.count >= 3) {
            alertMessage = "World name needs to be 3 characters or greater"
            showAlert = true
            return
        }
        
        if !(requirements.count >= 5) {
            alertMessage = "Requirement description is too short"
            showAlert = true
            return
        }
        
        if !(worldDescription.count >= 5) {
            alertMessage = "World description needs to be longer"
            showAlert = true
            return
        }
        
        if !email.isValidEmail() {
            alertMessage = "Please enter a valid email"
            showAlert = true
            return
        }
        
        if !(hashtags.count >= 3) {
            alertMessage = "Add more hashtags"
            showAlert = true
            return
        }
        
        submitWorld()
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
