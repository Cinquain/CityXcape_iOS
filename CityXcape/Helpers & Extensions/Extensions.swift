//
//  Extensions.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import Foundation
import SwiftUI
import MapKit
import Combine

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
    
    static var cx_orange: Color {
        return Color("cx_orange")
    }
    
    static var cx_green: Color {
        return Color("cx_green")
    }
    
    static var dark_grey: Color {
        return Color("darkgrey")
    }
    
    static var map_green: Color {
        return Color("map_green")
    }
    
    static var text_Color: Color {
        return Color("textColor")
    }
    
    static let neuBackground = Color(hex: "f0f0f3")
    static let dropShadow = Color(hex: "aeaec0").opacity(0.4)
    static let dropLight = Color(hex: "ffffff")
    
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
            )
    }
    
}


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
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
    
    func getCountry() -> String {
        let placemark = self.placemark
        var country: String = ""
        
        if placemark.country != nil {
            country = placemark.country!
        }
        return country
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    
    func converToHashTag() -> String {
        var newWords = [String]()
        let wordsArray = self.components(separatedBy:" ")
        for word in wordsArray {
            if word.count > 0 {
                let newWord = "#\(word.lowercased())"
                newWords.append(newWord)
            }
        }
        let hashtag = newWords.joined(separator:", ")
        return hashtag
    }
}

extension UIScreen {
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    
}

extension Date {
    
    func formattedDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.string(from: self)
        return date
    }
    
}






