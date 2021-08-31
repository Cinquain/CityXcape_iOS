//
//  Extensions.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import Foundation
import SwiftUI
import MapKit

extension Color {
    
    
    static var accent: Color {
        return Color("AccentColor")
    }
    
    static var background: Color {
        return Color("Background")

    }
    
    static var streePass: Color {
        return Color("StreetPass")
    }
    
    static var cx_blue: Color {
        return Color("cx_blue")
    }
    
}


extension MKMapItem {
    
    func getAddress() -> String {
        
        let placemark = self.placemark
        var addressString : String = ""
        if placemark.subLocality != nil {
            addressString = addressString + placemark.subLocality! + ", "
       }
        if placemark.thoroughfare != nil {
            addressString = addressString + placemark.thoroughfare! + ", "
       }
        if placemark.locality != nil {
            addressString = addressString + placemark.locality! + ", "
       }
        if placemark.country != nil {
            addressString = addressString + placemark.country! + ", "
       }
        if placemark.postalCode != nil {
            addressString = addressString + placemark.postalCode! + " "
       }
        
        return addressString
    }
}


