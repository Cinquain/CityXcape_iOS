//
//  TextFieldView.swift
//  CityXcape
//
//  Created by James Allan on 10/14/21.
//

import SwiftUI
import UIKit

struct TextFieldView: UIViewRepresentable {
    
    @Binding var text: String
   
    func makeUIView(context: Context) -> UITextField {
        let textField = getTextField()
        textField.delegate = context.coordinator
        return textField
    }
   
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    private func getTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        let placeholder = NSAttributedString(string: "Search Location", attributes: [.foregroundColor: UIColor.black])
        textField.attributedPlaceholder = placeholder
        return textField
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        
        init(text: Binding<String>) {
            self._text = text
        }
    }
}

