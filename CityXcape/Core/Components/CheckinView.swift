//
//  CheckinView.swift
//  CityXcape
//
//  Created by James Allan on 11/28/21.
//

import SwiftUI

struct CheckinView: View {
    
    @Environment(\.presentationMode) var presentationMode

    var spot: SecretSpot
    @StateObject var vm: SpotViewModel
    @State private var showComments: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var isDone: Bool = false
    var body: some View {
        ZStack {
            AnimationView()
            
            VStack {
                VStack {
                    Text("Congratulations! \n You earned 3 StreetCred")
                        .font(.title2)
                        .fontWeight(.thin)
                        .multilineTextAlignment(.center)


                    Image("pin_blue")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .opacity(0.2)
                    
                    Text("You've checked in \n Leave comment & photo for memories")
                        .fontWeight(.thin)
                        .multilineTextAlignment(.center)
                    
                    
                    
                    HStack(spacing: 20) {
                        Button {
                            //Present Sheet
                            showComments.toggle()
                        } label: {
                            VStack {
                                Image(systemName: "bubble.left.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .foregroundColor(.cx_blue.opacity(0.5))

                            
                            }
                        }
                        .sheet(isPresented: $showComments) {
                            //TDB
                        } content: {
                            CommentsView(spot: spot, vm: vm)
                        }

                        
                        Button(action: {
                            //TBd
                            vm.showPicker = true
                        }, label: {
                            VStack {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55)
                                    .foregroundColor(.cx_blue.opacity(0.5))
                                    .padding(.bottom, 10)
                                
                            }
                        })
                            .sheet(isPresented: $vm.showPicker) {
                                //TBD
                            } content: {
                                ImagePicker(imageSelected: $vm.journeyImage, sourceType: $sourceType)
                            }

                    }
                    .padding(.top, 30)
                    
                    Button {
                        //TBD
                        vm.getVerificationStamp(spot: spot) { success in
                            if success {
                                presentationMode.wrappedValue.dismiss()
                                vm.showStamp = true
                                vm.showVerifiers = true
                            }
                        }
                    } label: {
                        Text("Done")
                            .foregroundColor(.black)
                            .fontWeight(.thin)
                            .frame(width: 150, height: 40)
                            .background(Color.cx_orange.opacity(0.9))
                            .cornerRadius(25)
                            .padding(.top, 20)

                    }




                }
                .foregroundColor(.white)

                
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
    

    
}


struct CheckinView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let spot = SecretSpot(postId: "xfhug", spotName: "The Big Duck", imageUrls: ["https://upload.wikimedia.org/wikipedia/commons/2/21/Mandel_zoom_00_mandelbrot_set.jpg"], longitude: 1010, latitude: 01202, address: "1229 Spann avenue", description: "This the best secret spot in the world", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), price: 1, viewCount: 1, saveCounts: 1, isPublic: true, ownerId: "Cinquain", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", likeCount: 10, didLike: true)
        
        CheckinView(spot: spot, vm: SpotViewModel())
    }
}
