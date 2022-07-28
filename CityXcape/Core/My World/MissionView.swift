//
//  MissionView.swift
//  CityXcape
//
//  Created by James Allan on 2/23/22.
//

import SwiftUI
import MapKit

struct MissionView: View {
    @Environment(\.presentationMode) var presentationMode

    var spot: SecretSpot
    @StateObject var vm: MapViewModel
    @StateObject var spotModel: SpotViewModel
    
    let width = UIScreen.screenWidth * 0.90
    let height = UIScreen.screenHeight * 0.4
    let routeHeight = UIScreen.screenHeight * 0.65
    let routeColor: Color = .yellow
    let missionColor: Color = .map_green.opacity(0.8)
    let insets = EdgeInsets(top: 20, leading: 50, bottom: 20, trailing: 50)
    @State private var isRouting: Bool = false
    @State private var heading: Double = 0
 
    var body: some View {
        VStack {
            
            header
            
            Map(spot: spot, vm: vm, header: $heading)
            .frame(width: width, height: isRouting ? routeHeight : height)
            .colorScheme(.dark)
            .padding(insets)
            .cornerRadius(5)
            .animation(.easeOut)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    heading = 180
                }
            }
            
            
            
            if isRouting {
                Button {
                    spotModel.openGoogleMap(spot: spot)
                } label: {
                    Text(vm.routeText)
                        .font(.subheadline)
                }

            }
            
            Text(isRouting ? "Please checkin when you arrive" : vm.missionText)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
                .padding(.bottom, 30)
            
            Button {
                //
                vm.checkIfVerifiable(spot: spot)
            } label: {
                Text("Checkin")
                    .foregroundColor(.black)
                    .fontWeight(.thin)
                    .font(.title3)
                    .frame(width: 180, height: 45)
                    .background(routeColor)
                    .cornerRadius(25)
                    .animation(.easeOut)
                   
            }
            .padding(.bottom, 4)
            .fullScreenCover(isPresented: $vm.showCheckin) {
                self.presentationMode.wrappedValue.dismiss()
            } content: {
                CheckinView(spot: spot, vm: spotModel)
            }

            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
        }
        .foregroundColor(.white)
        .background(
            LinearGradient(gradient: Gradient(stops: [
                 Gradient.Stop(color: .black, location: 0.40),
                 Gradient.Stop(color: .cx_orange, location: 3.0),
            ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
        )
        .alert(isPresented: $vm.showAlert) {
            return Alert(title: Text(vm.alertMessage))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                 isRouting = true
                 vm.calculateRoute(spot: spot)
                 vm.routeText = "\(String(format: "%.1f", spot.distanceFromUser)) miles away."
            }
        }
    }
    
    
    
    private var header: some View {
        return  HStack {
            Spacer()
            Image("pin_blue")
                .resizable()
                .scaledToFit()
                .frame(width: 40)
            
            Text("\(spot.spotName)")
                .font(.title)
                .fontWeight(.thin)
                .foregroundColor(.white)
                .padding(.bottom, 5)
                .lineLimit(1)
            
            Spacer()
        }
    }
    
    
}


struct Map: UIViewRepresentable {
    
    var spot: SecretSpot
    @StateObject var vm: MapViewModel
    
    @Binding var header: Double
    
    let manager = LocationService.instance.manager
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    let mapview = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        setupRegionForMap()
        setupAnnotation()
        mapview.showsCompass = false
        mapview.showsUserLocation = true
        let camera = MKMapCamera(lookingAtCenter: .init(latitude: spot.latitude, longitude: spot.longitude), fromDistance: 5000, pitch: 0, heading: 0)
        mapview.setCamera(camera, animated: true)
        mapview.delegate = context.coordinator
        return mapview
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //I'll be back
        if vm.route == nil {
            
            let camera = MKMapCamera(lookingAtCenter: .init(latitude: spot.latitude, longitude: spot.longitude), fromDistance: 5000, pitch: 0, heading: header)
            uiView.setCamera(camera, animated: true)
        
            
        }
    
        if let route = vm.route {
            uiView.addOverlay(route.polyline)
            uiView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
      

    }
    
    typealias UIViewType = MKMapView
    
    fileprivate func setupRegionForMap() {
        let location = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapview.region = region
    }
    
    fileprivate func setupAnnotation() {
        let annotation = MKPointAnnotation()
        let location = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
        annotation.coordinate = location
        annotation.title = spot.spotName
        mapview.addAnnotation(annotation)
    }
    
    
    //Coordinator pattern
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: Map
        init(_ parent: Map) {
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
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(named: "cx_blue")
            renderer.lineWidth = 2
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            
            parent.vm.updateRoute(spot: parent.spot)
            
        }
        
        
        
    }
}


struct MissionView_Previews: PreviewProvider {
    static var previews: some View {

        MissionView(spot: SecretSpot.spot, vm: MapViewModel(), spotModel: SpotViewModel())
    }
}
