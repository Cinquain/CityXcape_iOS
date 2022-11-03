//
//  EmailSigninViewModel.swift
//  CityXcape
//
//  Created by James Allan on 2/11/22.
//

import Foundation
import SwiftUI


class EmailSigninViewModel: ObservableObject {
    
    
    var width = UIScreen.screenWidth * 0.85
    var height = UIScreen.screenHeight * 0.42
    
    @Published var videoUrl: URL?
    @Published var showPicker: Bool = false
    @Published var userImage: UIImage?
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var addedPic: Bool = false
    @Published var disable: Bool = false 
    
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var message: String = ""
    
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func isValidPassword() -> Bool {
        if password.count > 4 {
            return true
        } else {
            return false
        }
    }
    
    func isValidUsername() -> Bool {
        if username.count >= 3 {
            return true
        } else {
            return false
        }
    }
    
    
    func login(completion: @escaping (_ success: Bool) -> ()) {
            disable = true
        if !isValidEmail() {
            message = "Please enter a valid email"
            completion(false)
            disable = false
            return
        }
        
        if !isValidPassword() {
            message = "Please enter a valid password"
            disable = false
            completion(false)
            return
        }
        
        
        AuthService.instance.signinWIthEmail(email: email, password: password) { success, error  in
            if success {
                completion(success)
            } else {
                print("Failed to login in user")
                self.message = error ?? ""
                self.disable = false
                completion(false)
            }
    }
        
    }
    
    
    func createNewAccount(completion: @escaping (_ success: Bool) -> ()) {
        
         disable = true
        
        if userImage == nil {
            message = "Please add a profile picture"
            disable = false
            completion(false)
            return
        }
        
        if !isValidUsername() {
            message = "Username is not valid"
            disable = false
            completion(false)
            return
        }
        
        if !isValidEmail() {
            message = "Please enter a valid email"
            disable = false
            completion(false)
            return
        }
        
        if !isValidPassword() {
            message = "Please enter a valid password"
            disable = false
            completion(false)
            return
        }
        
        let image = userImage ?? UIImage()
        AuthService.instance.signUpWithEmail(username: username, email: email, password: password, profileImage: image) { uid, error  in
            
            if error != nil {
                self.message = error ?? "Error signing up "
                self.disable = false
                completion(false)
                return
            }
            
            if let userId = uid {
                AuthService.instance.loginUserToApp(userId: userId) { success in
                    if success {
                        completion(success)
                    } else {
                        print("Error logging in user")
                        self.message = error ?? "Error Creating Account"
                        self.disable = false
                        completion(false)
                    }
                }
            }
        }
        
        
    }
    
    
}
