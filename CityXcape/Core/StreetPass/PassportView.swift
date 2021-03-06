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
    @State var verification: Verification
    @StateObject var vm: JourneyViewModel
    var width: CGFloat = UIScreen.screenWidth
    @State private var currentObject: Verification?
    @State private var obect2: Verification?
    
    var body: some View {
        ScrollView {
            
            memoryView

            buttonRow

            Spacer()

            stamp
            
            downArrow
            
            
        }
        .background(Color.cx_cream.edgesIgnoringSafeArea(.all))
        .onDisappear(perform: {
            vm.url = nil
        })
        .onAppear {
            vm.url = nil
            vm.allowshare = false
            vm.getVerificationImage(object: verification)
        }
       
    }
}



extension PassportView {
    
    private var memoryView: some View {
        
        VStack(spacing: 10) {
            Button {
               currentObject = verification
            } label: {
                ZStack {
                    Color.white
                    WebImage(url: URL(string: vm.url == nil ? verification.imageUrl : vm.url ?? ""))
                        .resizable()
                        .frame(width: width - 40, height: width - 40)
                        
                }
                .frame(width: width - 20, height: width - 20)
            }
            .actionSheet(item: $currentObject) { item in
                getActionSheet(object: item)
            }
            .sheet(isPresented: $vm.showPicker, onDismiss: {
                vm.replaceStampImage { url in
                    vm.url = url
                }
            }, content: {
                ImagePicker(imageSelected: $vm.passportImage, sourceType: $vm.sourceType)
            })
           


           
          
            VStack(spacing: 0) {
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
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
             
                    Spacer()
                }
                
                HStack {
                    Text(verification.comment)
                        .font(Font.custom("Savoye LET", size: 25))
                        .foregroundColor(.black)
                    
                }
                .padding(.horizontal, 20)
            }
            .alert(isPresented: $vm.showAlert) {
                return Alert(title: Text(vm.alertMessage))
            }
            
            
        }
        
    }
    
    private var stamp: some View {
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
    }
    
    private var buttonRow: some View {
        HStack(spacing: 0) {
        
                Button {
                    vm.showShareSheet.toggle()
               } label: {
                    
                    HStack {
                        
                        Image("text_share")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                            .foregroundColor(.black)
                        
                    }
                    .padding(.horizontal, 20)
                    .sheet(isPresented: $vm.showShareSheet) {
                        ShareSheetView(photo: vm.passportImage ?? UIImage(), title: verification.name)
                    }
                    
                }
            
            
            Button {
                vm.shareInstaStamp(object: verification)
            } label: {
                Image("ig_share")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                    .foregroundColor(.black)

            }

            
            Spacer()
        }
        .padding(.horizontal, 10)
        .opacity(vm.allowshare ? 1 : 0)
        .animation(.easeIn, value: vm.allowshare)
    }
    
    
    private var downArrow: some View {
        HStack {
            
            Spacer()
            
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .opacity(0.5)
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 10)
    }
    
    func getActionSheet(object: Verification) -> ActionSheet {
          
            return ActionSheet(title: Text("Image Source"), message: nil, buttons: [
                
            .default(Text("Camera"), action: {
                vm.updateStampId = ""
                vm.updateStampId = object.postId
                vm.sourceType = .camera
                vm.showPicker = true
             
            }),
            
            .default(Text("Photo Library"), action: {
                vm.updateStampId = ""
                vm.updateStampId = object.postId
                vm.sourceType = .photoLibrary
                vm.showPicker = true
               
            }),
            
            .cancel()
            ])

        
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
        
        PassportView(verification: verification, vm: JourneyViewModel())
    }
}
