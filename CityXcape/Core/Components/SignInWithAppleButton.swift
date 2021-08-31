//
//  SignInWithAppleButton.swift
//  CityXcape
//
//  Created by James Allan on 8/21/21.
//

import Foundation
import SwiftUI
import AuthenticationServices


struct SignInWithAppleButton: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .white)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
    
 
}
