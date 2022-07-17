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
    @State private var showButtons: Bool = false
    var body: some View {
        ZStack {
            AnimationView()
            
            VStack {
                VStack {
                
                    title

                    bluePin
                    
                }
                .foregroundColor(.white)
                
                
                if !spot.verified {
                    buttonRow
                }
                
                if spot.verified {
                    buttonRow
                        .animation(.easeOut(duration: 0.5), value: showButtons)
                        .opacity(showButtons ? 1 : 0)
                    replaceButton
                }
                
                finishButton

                Spacer()
                    .frame(height: 100)
                
                arrowButton

                
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $vm.showAlert) {
            return Alert(title: Text(vm.alertMessage))
        }
        .actionSheet(isPresented: $vm.showActionSheet) {
            ActionSheet(title: Text("Source Options"), message: nil, buttons: [
                .default(Text("Camera"), action: {
                    vm.sourceType = .camera
                    vm.showPicker.toggle()
                }),
                .default(Text("Photo Library"), action: {
                    vm.sourceType = .photoLibrary
                    vm.showPicker.toggle()
                })
            ])
            
        }
    }
    

    
}

extension CheckinView {
    
    private var title: some View {
        Text(spot.verified ? "Welcome back!" : "Almost Done... \n Post comment & photo")
            .font(.title2)
            .fontWeight(.thin)
            .multilineTextAlignment(.center)
    }
    
    private var bluePin: some View {
        ZStack {
            Image("pin_blue")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(vm.journeyImage == nil ? .gray : .cx_blue)
                .frame(height: 200)
                .opacity(vm.journeyImage == nil ? 0.2 : 1)
                .overlay(
                    Image(uiImage: vm.journeyImage ?? UIImage())
                        .resizable()
                        .frame(width: 145, height: 145)
                        .scaledToFit()
                        .clipShape(Circle())
                        .padding(.bottom, 25)
            )
            
            ProgressView()
                .scaleEffect(3)
                .offset(y: -10)
                .opacity(vm.isLoading ? 1 : 0)
        }
    }
    
    private var buttonRow: some View {
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
                        .foregroundColor(
                            !vm.comment.isEmpty ?
                                .cx_blue : .gray)

                
                }
            }
            .sheet(isPresented: $showComments) {
                //TDB
            } content: {
                CommentsView(spot: spot, vm: vm)
            }

            
            Button(action: {
                //TBd
                vm.showActionSheet = true
            }, label: {
                VStack {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55)
                        .foregroundColor(
                            vm.addedImage ?
                                .cx_blue : .gray)
                        .padding(.bottom, 10)
                    
                    
                }
            })
                .sheet(isPresented: $vm.showPicker) {
                    //TBD
                    vm.addedImage = true
                } content: {
                    ImagePicker(imageSelected: $vm.journeyImage, sourceType: $vm.sourceType)
                }

        }
        .padding(.top, 30)
    }
    
    private var replaceButton: some View {
        Button {
            showButtons.toggle()
        } label: {
            Text("Replace Comment & Photo")
                .fontWeight(.thin)
                .foregroundColor(.white)
        }
    }
    
    
    private var finishButton: some View {
        Button {
            if spot.verified {
                vm.updateVerificationStamp(spot: spot) { success in
                    if success {
                        vm.isLoading = false
                        presentationMode.wrappedValue.dismiss()
                        vm.showVerifiers = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            vm.showStamp = true
                        }
                    }
                }
            } else {
                vm.getVerificationStamp(spot: spot) { success in
                    if success {
                        vm.isLoading = false
                        presentationMode.wrappedValue.dismiss()
                        vm.showVerifiers = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            vm.showStamp = true
                        }
                    }
                }
            }
           
        } label: {
            Text(spot.verified ? "Check-in" : "Done")
                .foregroundColor(.black)
                .fontWeight(.thin)
                .frame(width: 150, height: 40)
                .background(Color.cx_orange.opacity(0.9))
                .cornerRadius(25)
                .padding(.top, 20)

        }
    }
    
    private var arrowButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("arrow")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .opacity(0.5)
        }
    }
    
    
}


struct CheckinView_Previews: PreviewProvider {
    
    static var previews: some View {
        CheckinView(spot: SecretSpot.spot, vm: SpotViewModel())
    }
}
