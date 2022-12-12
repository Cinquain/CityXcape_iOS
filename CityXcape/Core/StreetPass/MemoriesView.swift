//
//  MemoriesView.swift
//  CityXcape
//
//  Created by James Allan on 11/28/22.
//

import SwiftUI

struct MemoriesView: View {
    @Environment(\.presentationMode) var presentationMode

    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var username: String?
    
    @StateObject var vm: JourneyViewModel
    @State var currentStamp: Verification?
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 180))
    ]
    var body: some View {
        VStack {
            
            header
            
            Divider()
                .frame(height: 1)
                .foregroundColor(.gray)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    
                    ForEach(vm.verifications.sorted(by: {$0.time > $1.time})) { stamp in
                        Button {
                            currentStamp = stamp
                        } label: {
                            StampThumbnail(stamp: stamp)
                        }
                        .fullScreenCover(item: $currentStamp) { stamp in
                            PassportView(verification: stamp, vm: vm)
                        }
                    }
                    
                }
            }
            
           
        }
        .background(Color.black)
    }
    
    fileprivate func getTitle() -> String {
        if vm.verifications.count > 1 {
            return "You've collected \(vm.verifications.count) stamps"
        } else {
            return "You've collected \(vm.verifications.count) stamp"
        }
    }
}

extension MemoriesView {
    
    private var header: some View {
        HStack {
            
            UserDotView(imageUrl: profileUrl ?? "", width: 50)
            
            Text(getTitle())
                .fontWeight(.thin)
                .foregroundColor(.white)
            
            Spacer()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.diamond.fill")
                    .font(.title)
                    .foregroundColor(.cx_orange)
            }

        }
        .padding(.horizontal, 20)
    }
}

struct MemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        MemoriesView(vm: JourneyViewModel())
    }
}
