//
//  ImageSaver.swift
//  CityXcape
//
//  Created by James Allan on 6/28/22.
//

import Foundation
import UIKit


class ImageSaver: NSObject {
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
         print("Save finished!")
     }
    
}
