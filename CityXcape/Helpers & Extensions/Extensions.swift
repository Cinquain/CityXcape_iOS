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
    
    static var cx_green: Color {
        return Color("cx_green")
    }
    
    static var dark_grey: Color {
        return Color("darkgrey")
    }
    
    static var text_Color: Color {
        return Color("textColor")
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
        if addressString == "" {
            return "Long: \(String(format: "%.4f", self.placemark.coordinate.longitude)), Lat:\(String(format: "%.4f", self.placemark.coordinate.latitude))"
        } else {
            return addressString
        }
        
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
    
    func placeholder<Content: View>(
          when shouldShow: Bool,
          alignment: Alignment = .leading,
          @ViewBuilder placeholder: () -> Content) -> some View {

          ZStack(alignment: alignment) {
              placeholder().opacity(shouldShow ? 1 : 0)
              self
          }
      }
    
    func hideKeyboard() {
         let resign = #selector(UIResponder.resignFirstResponder)
         UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
     }
}


extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}



