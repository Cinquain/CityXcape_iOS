//
//  NewMessageView.swift
//  CityXcape
//
//  Created by James Allan on 8/2/22.
//

import SwiftUI

struct NewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: MessageViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                ForEach(0..<10) { num in
                    VStack {
                        Button {
                            print(num)
                            presentationMode.wrappedValue.dismiss()
                            vm.showLogView.toggle()
                        } label: {
                            userView
                        }
                        
                        Divider()
                    }
                }
                
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .colorScheme(.dark)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
        }
        .colorScheme(.dark)
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView(vm: MessageViewModel())
    }
}

extension NewMessageView {
    
    private var userView: some View {
        HStack {
            UserDotView(imageUrl:"https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=1a4c018a-d539-4c95-87ca-fdec61f8e73c", width: 60)
                
            
            Text("Cinquain")
                .fontWeight(.thin)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
