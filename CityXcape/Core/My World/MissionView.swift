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
                .padding(.bottom, 20)
            
            Map(spot: spot, vm: vm, header: $heading)
                .frame(width: width, height: isRouting ? routeHeight : height)
            .colorScheme(.dark)
            .padding(insets)
            .cornerRadius(5)
            .animation(.easeOut)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    heading = 180
                }
            }
            
            
            Text("\(spot.spotName)")
                .font(.title)
                .fontWeight(.thin)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            Text(isRouting ? vm.routeText : vm.missionText)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
                .padding(.bottom, 30)
            
            Button {
                //
                if isRouting {
                    vm.checkIfVerifiable(spot: spot)
                } else {
                    vm.routeText = "\(String(format: "%.1f", spot.distanceFromUser)) miles away. Press checkin when you arrive"
                    isRouting = true
                    vm.calculateRoute(spot: spot)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        spotModel.openGoogleMap(spot: spot)
                    }
                    
                }
             
            } label: {
                Text(isRouting ? "Checkin" : "Route")
                    .foregroundColor(.black)
                    .fontWeight(.thin)
                    .font(.title3)
                    .frame(width: 180, height: 45)
                    .background(isRouting ? routeColor : missionColor)
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
                if isRouting {
                    isRouting = false
                    vm.route = nil
                } else {
                    presentationMode.wrappedValue.dismiss()
                }
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
    }
    
    
    
    private var header: some View {
        return  HStack {
            Spacer()
            
            Image("Scout Life")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
              
            Text("Explore Mission")
                .font(.title3)
                .foregroundColor(.white)
                .fontWeight(.thin)
            
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
        
        let spot = SecretSpot(postId: "disnf", spotName: "MIT Museum", imageUrls: [ "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2FEh02xKtGRDCgGKRUDLPf%2F1?alt=media&token=94cdd31e-d095-4946-8092-e35b85cb2aa1"], longitude: -71.0866651, latitude: 42.3621321, address: "1229 Spann avenue", description: "This 57,000 square foot museum display the countless innovations that came out of MIT. Great place for technology enthusiast and visit at the museum is only $10 for adults.", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), price: 1, viewCount: 1, saveCounts: 1, isPublic: true, ownerId: "q4SALDGpjtZLIVtVibHMQa8NpwD3", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", likeCount: 10, didLike: true, verifierCount: 0)
        
        MissionView(spot: spot, vm: MapViewModel(), spotModel: SpotViewModel())
    }
}
