//
//  ShareSheetView.swift
//  CityXcape
//
//  Created by James Allan on 5/2/22.
//

import SwiftUI
import UIKit
import LinkPresentation


struct ShareSheetView: UIViewControllerRepresentable {
    
    let photo: UIImage
    let title: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let text = "Checkout my stamp for \(title)"
        let itemSource = ShareActivityItemSource(shareText: text, shareImage: photo)
        let activityItems: [Any] = [photo, text, itemSource]
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        //I'll be back
    }
    
}



class ShareActivityItemSource: NSObject, UIActivityItemSource {
    
    var shareText: String
    var shareImage: UIImage
    var linkMetaData = LPLinkMetadata()
    
    init(shareText: String, shareImage: UIImage) {
        self.shareText = shareText
        self.shareImage = shareImage
        linkMetaData.title = shareText
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: "fire") as Any
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetaData
    }
    
}
