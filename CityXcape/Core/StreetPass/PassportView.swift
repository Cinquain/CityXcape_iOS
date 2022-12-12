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
    @State private var currentStamp: Verification?
    
    var body: some View {
        ScrollView {
            
            memoryView
                
            Spacer()

            stamp
            
            downArrow
            
            
        }
        .background(LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: .black, location: 0.40),
            Gradient.Stop(color: .cx_orange, location: 3.0),
        ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
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
                        .frame(width: width - 15, height: width - 15)
                    
                    WebImage(url: URL(string: vm.url == nil ? verification.imageUrl : vm.url ?? ""))
                        .resizable()
                        .frame(width: width - 40, height: width - 40)
                        
                }
                
            }
            .actionSheet(item: $currentObject) { item in
                getActionSheet(object: item)
            }
            .sheet(isPresented: $vm.showPicker, onDismiss: {
                vm.replaceStampImage { url in
                    vm.url = url
                }
            }, content: {
                ImagePicker(imageSelected: $vm.passportImage, videoURL: $vm.videoUrl, sourceType: $vm.sourceType)
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
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                    
                        Spacer()
                    }
                
                Text(verification.comment)
                       .font(Font.custom("Savoye LET", size: 25))
                       .foregroundColor(.white)
                       .sheet(item: $currentStamp) { stamp in
                           StampMemoriesView(stamp: stamp)
                       }
                     
                                          
                    
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
        .contextMenu(menuItems: {
            
            Button {
                vm.shareInstaStamp(object: verification)
            } label: {
                HStack {
                    Text("Share")
                    Image("ig_share")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                }
               
            }
          
            Button {
                vm.loadCommentsFor(id: verification.id)
            } label: {
               Label("Comments", systemImage: "bubble.left.fill")
            }
            .sheet(isPresented: $vm.showComments) {
                StampCommentView(stamp: verification, comments: vm.comments)
            }
          
            
             Button {
                 currentStamp = verification
             } label: {
                 Label("Memories", systemImage: "photo.on.rectangle")
             }
             
            


        })
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
        PassportView(verification: Verification.demo, vm: JourneyViewModel())
    }
}
