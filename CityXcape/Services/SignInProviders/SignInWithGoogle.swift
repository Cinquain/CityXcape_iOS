//
//  SignInWithGoogle.swift
//  CityXcape
//
//  Created by James Allan on 9/2/21.
//

import Foundation
import Firebase
import GoogleSignIn
import SwiftUI
import FirebaseAuth



class SignInWithGoogle: NSObject {
    
    
    static let instance  = SignInWithGoogle()
    var onboardingView: OnboardingView!
    
    func startSignInWithGoogleFlow(view: OnboardingView) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        self.onboardingView = view
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        let view = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance.signIn(with: config, presenting: view!) { [unowned self] user, error in

          if let error = error {
            // ...
            print("Error signing in with google", error.localizedDescription)
            self.onboardingView.showError.toggle()
            return
          }
            guard let fullname: String = user?.profile?.name else {return}
            guard let email: String = user?.profile?.email else {return}
            guard let authentication = user?.authentication else {return}
            guard let idToken = authentication.idToken else {return}

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

          // ..
        self.onboardingView.connectToFirebase(name: fullname, email: email, provider: "Google", credential: credential)
         
        }
        
    
    }
    
    
    
    
}
