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
    
    static var cx_cream: Color {
        return Color("cx_cream")
    }
    
    static var stamp_red: Color {
        return Color("stamp_red")
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
    
    static var graph: Color {
        return Color("graph")
    }
    
    static var traffic_red: Color {
        return Color("traffic_red")
    }
    
    static var traffic_green: Color {
        return Color("traffic_green")
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


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
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
    
    
    
    func getState() -> String {
        let placemark = self.placemark
        var location = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude) //changed!!!

        var state: String = ""
        if placemark.administrativeArea != nil {
            state = placemark.locality!
        }
        
        if state == "" {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                   guard error == nil else {
                       print("Error finding reverse geo-location")
                       return
                   }
                    guard placemarks?.count ?? 0 > 0 else {return}
                    let pm = placemarks?[0]
                    state = pm?.administrativeArea ?? ""
               })
        }
        return state
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

extension HomeView {
    
    func handleDeepLink(_ link: DeepLink) {
        
        switch link {
        case .home:
            selectedTab = 0
        case .discover:
            selectedTab = 1
        case .streetPass:
            selectedTab = 3
        }
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
    
    func snapshot() -> UIImage {
        
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        
    }
    //End of vie
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
                if word.contains("#") {
                    let newWord = word.replacingOccurrences(of: "#", with: "")
                    newWords.append("#\(newWord.capitalizingFirstLetter())")
                } else {
                    let newWord = "#\(word.capitalizingFirstLetter())"
                    newWords.append(newWord)
                }
            }
        }
        let hashtag = newWords.first ?? ""
        return hashtag
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
}



extension UIScreen {
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    
}

extension CLLocationCoordinate2D {
    
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

extension Date {
    
    func formattedDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.string(from: self)
        return date
    }
    
    func stringDescription() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
        let date = dateFormatter.string(from: self)
        return date
    }
    
    func timeFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.string(from: self)
        return date
    }
    
    func timeAgo() -> String {

        let secondsAgo = Int(Date().timeIntervalSince(self))

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week

        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
    
}







