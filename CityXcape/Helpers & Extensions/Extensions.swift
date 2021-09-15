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
        
        if placemark.subThoroughfare != nil {
            addressString = addressString + placemark.subThoroughfare! + " "
        }
        
        if placemark.thoroughfare != nil {
            addressString = addressString + placemark.thoroughfare! + ", "
       }
        if placemark.locality != nil {
            addressString = addressString + placemark.locality! + ", "
       }
     
        if placemark.postalCode != nil {
            addressString = addressString + placemark.postalCode! + " "
       }
        
        return addressString
    }
    
    func getCity() -> String {
        let placemark = self.placemark
        var city: String = ""
        
        if placemark.locality != nil {
            city = placemark.locality!
        }
        return city
    }
    
    func getPostCode() -> Int {
        let placemark = self.placemark
        var zipcode: Int = 0
        if placemark.postalCode != nil {
            zipcode = Int(placemark.postalCode!) ?? 0
        }
        return zipcode
    }
}



extension View {
    func standardButtonFormatting(textColor: Color, color: Color) -> some View {
        modifier(StandardButton(textColor: textColor, color: color))
    }
    
    func withPresstableStyle() -> some View {
        buttonStyle(StandardPressStyle())
    }
}



