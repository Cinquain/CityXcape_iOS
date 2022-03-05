//
//  MyJournal.swift
//  CityXcape
//
//  Created by James Allan on 3/1/22.
//

import SwiftUI

struct MyJournal: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm: JourneyViewModel

    var body: some View {
        
        ScrollView {
            TabView {
                
                ForEach(vm.verifications) { verification in
                    PassportView(verification: verification)
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
            
            }
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height - 50)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
        }
        .background(Color.cx_cream.edgesIgnoringSafeArea(.all))
        
        
        //End of VStack
    }
}

struct MyJournal_Previews: PreviewProvider {

    static var previews: some View {
        MyJournal(vm: JourneyViewModel())
    }
}
