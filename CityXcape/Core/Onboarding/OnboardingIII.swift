//
//  OnboardingIII.swift
//  CityXcape
//
//  Created by James Allan on 9/14/22.
//

import SwiftUI
import MapKit

struct OnboardingIII: View {
    
    
    let width = UIScreen.screenWidth * 0.90
    let height = UIScreen.screenHeight * 0.4
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        VStack {
            
            OnboardingMap()
                .frame(width: width, height: height)
                .colorScheme(.dark)
                .cornerRadius(5)
            
            HStack {
                Spacer()
                VStack {
                    Text("Build Your Journey")
                        .font(.title)
                    .fontWeight(.thin)
                    Text("by collecting stamps")
                        .font(.subheadline)
                        .fontWeight(.thin)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.bottom, 50)
            
            VStack {
                
                Button {
                    //TBD
                    showAlert.toggle()
                } label: {
                    
                    HStack {
                        
                    Image("pin_blue")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                            
                        Text("87 Locations")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .frame(width: 100, height: 50, alignment: .leading)
                    }
                }
                
                Button {
                    //TBD
                    showAlert.toggle()
                } label: {
                    HStack {
                        Image("city")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Text("12 Cities")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .frame(width: 100, height: 50, alignment: .leading)
                    }
                }
                
                Button {
                    //TBD
                    showAlert.toggle()
                } label: {
                    HStack {
                        Image("Stamp")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(width: 50)
                            .opacity(0.8)
                            .padding(.top, 7)
                        
                        Text("Memories")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .frame(width: 100, height: 50, alignment: .leading)
                    }
                }
                .padding(.top, 7)
               
            }
            
            
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(stops: [
                Gradient.Stop(color: .black, location: 0.40),
                Gradient.Stop(color: .cx_orange, location: 3.0),
            ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
        )
        .alert(isPresented: $showAlert) {
            return Alert(title: Text("Start saving & visiting places to build your journey"))
        }
    }
}


struct OnboardingMap: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(mapview)
    }
    
     
     
    
    let annotations: [MKPointAnnotation] = [
        MKPointAnnotation(__coordinate: .init(latitude: 44.97464652707689, longitude: -93.27323913604867)),
        MKPointAnnotation(__coordinate: .init(latitude: 40.75891896697178, longitude: -73.9786521437948)),
        MKPointAnnotation(__coordinate: .init(latitude: 37.789510259576915, longitude: -122.39100100151458)),
        MKPointAnnotation(__coordinate: .init(latitude: 25.808629307235062, longitude: -80.18624238796812)),
        MKPointAnnotation(__coordinate: .init(latitude:  42.94745798746452, longitude: -122.10751201309502)),
        MKPointAnnotation(__coordinate: .init(latitude: 43.87644410438688, longitude: -103.46105151730195)),
        MKPointAnnotation(__coordinate: .init(latitude: 32.77888724898725, longitude: -96.80643997278794)),
        MKPointAnnotation(__coordinate: .init(latitude: 36.10045578236695, longitude: -112.11248462407075)),
        MKPointAnnotation(__coordinate: .init(latitude:  41.51415672112015, longitude: -81.59837938800032)),
        MKPointAnnotation(__coordinate: .init(latitude:  33.76997622356599, longitude: -84.3938263294674)),
        MKPointAnnotation(__coordinate: .init(latitude:  35.473359278207475, longitude: -97.5170700304227)),
        MKPointAnnotation(__coordinate: .init(latitude:  40.570363859946575, longitude:  -111.65586048683312)),
    ]
    
    let mapview = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapview.showsCompass = false
        mapview.isUserInteractionEnabled = true
        mapview.delegate = context.coordinator
        mapview.addAnnotations(annotations)
        mapview.showAnnotations(mapview.annotations.filter({$0 is MKPointAnnotation}), animated: true)
        return mapview
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    
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

struct OnboardingIII_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingIII()
    }
}
