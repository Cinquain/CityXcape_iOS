//
//  ShareSheetView.swift
//  CityXcape
//
//  Created by James Allan on 5/2/22.
//

import Foundation
import SwiftUI


struct ShareSheetView: UIViewControllerRepresentable {
    
    let activityItems: [URL]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        //I'll be back
    }
    
}
