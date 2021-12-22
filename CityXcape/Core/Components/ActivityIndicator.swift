//
//  ActivityIndicator.swift
//  CityXcape
//
//  Created by James Allan on 12/22/21.
//

import UIKit
import SwiftUI


struct ActivityIndicator: UIViewRepresentable {
    
    
    @Binding var isAnimating: Bool
    
    func makeUIView(context: Context) -> some UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        return activityIndicator
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

