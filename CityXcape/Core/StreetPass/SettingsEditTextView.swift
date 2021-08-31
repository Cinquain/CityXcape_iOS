//
//  SettingsEditTextView.swift
//  CityXcape
//
//  Created by James Allan on 8/24/21.
//

import SwiftUI

struct SettingsEditTextView: View {
    
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeHolder: String
    
    var body: some View {
        
        VStack {
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
            TextField(placeHolder, text: $submissionText)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.1))
                .accentColor(.black)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
            
            
            Button(action: {
                
            }, label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(12)
            })
            .accentColor(Color.orange)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleDisplayMode(.large)
        
    }
}

struct SettingsEditTextView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsEditTextView(title: "Edit Username", description: "Change Your Username", placeHolder: "Cinquain")
        }
      
    }
}
