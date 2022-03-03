//
//  JourneyView.swift
//  CityXcape
//
//  Created by James Allan on 3/2/22.
//

import SwiftUI
import MapKit

struct JourneyView: View {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?

    let width = UIScreen.screenWidth * 0.90
    let height = UIScreen.screenHeight * 0.4
    
    @StateObject var vm: JourneyViewModel = JourneyViewModel()
    
    var body: some View {
        VStack {
            HStack {
                VStack(spacing: 0) {
                    UserDotView(imageUrl: profileUrl ?? "", width: 80, height: 80)
                    Text(displayName ?? "")
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                }
                Text("My Journey")
                    .font(Font.custom("Lato", size: 35))
                    .foregroundColor(.white)
                    .padding(.bottom, 12)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            JourneyMap(vm: vm)
                .frame(width: width, height: height)
                .colorScheme(.dark)
                .cornerRadius(5)
            
            Spacer()
                .frame(height: width * 0.15)
           
            HStack(alignment: .center){
                
                VStack {
                    Image("pin_blue")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Image("city")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Image("globe")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Image("Scout Life")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                
                VStack(alignment: .leading) {
                    
                    Button {
                        //TBD
                    } label: {
                        
                    Text("90 Locations")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .frame(width: 100, height: 50, alignment: .leading)
                    }

                    Button {
                        //TBD
                    } label: {
                        Text("\(vm.cities.keys.count) Cities")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .frame(width: 100, height: 50, alignment: .leading)
                    }

                    
                    Button {
                        //TBD
                    } label: {
                    Text("1 Country")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .frame(width: 100, height: 50, alignment: .leading)
                    }
                    
                    Button {
                        //TBD
                    } label: {
                    Text("Travel Diary")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .frame(width: 100, height: 50, alignment: .leading)
                    }

                }
                //End of button HStack
            }
  
            
            
            Spacer()
            
       
        }
        .background(
            LinearGradient(gradient: Gradient(stops: [
                Gradient.Stop(color: .black, location: 0.40),
                Gradient.Stop(color: .cx_orange, location: 3.0),
            ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
        )

    }
}

struct JourneyMap: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(mapview)
    }
    
    var vm: JourneyViewModel
    let mapview = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapview.showsCompass = false
        mapview.isUserInteractionEnabled = true
        
        let annotations = vm.verifications.map({MKPointAnnotation(__coordinate: .init(latitude: $0.latitude, longitude: $0.longitude))})
        mapview.addAnnotations(annotations)
        mapview.showAnnotations(mapview.annotations.filter({$0 is MKPointAnnotation}), animated: true)
        mapview.delegate = context.coordinator
        return mapview
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //TBD
        
        
    }
    
    
    typealias UIViewType = MKMapView
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MKMapView
        
        init(_ parent: MKMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if (annotation is MKPointAnnotation) {
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "spot")
                let image = UIImage(named: "marker")
                annotationView.image = image
                return annotationView
            }
            return nil
        }
        
    }
    
}

struct JourneyView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyView()
    }
}
