//
//  TrailMapView.swift
//  CityXcape
//
//  Created by James Allan on 4/11/23.
//

import SwiftUI
import MapKit
struct TrailMapView: View {
    @State var spots: [SecretSpot]
    
    var body: some View {
        Heatmap(secretspots: spots)
            .colorScheme(.dark)
            .edgesIgnoringSafeArea(.all)
    }
}

struct Heatmap: UIViewRepresentable {
    var secretspots: [SecretSpot]
    @State var center: CLLocationCoordinate2D?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //TBD
        if secretspots.count > 0 {
            uiView.removeAnnotations(uiView.annotations)
            
            let annotations = secretspots.map({MKPointAnnotation(__coordinate: .init(latitude: $0.latitude, longitude: $0.longitude))})
            
            annotations.forEach { annotation in
                uiView.addAnnotation(annotation)
            }
            
            uiView.showAnnotations(uiView.annotations.filter({$0 is MKPointAnnotation}), animated: true)
        }
    }
    
    func setupRegion() {
        let orderedSpots = secretspots.sorted(by: {$0.distanceFromUser < $1.distanceFromUser})
        guard let firstSpot = orderedSpots.first else {return}
        let center = CLLocationCoordinate2D(latitude: firstSpot.latitude, longitude: firstSpot.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: Heatmap
        
        init(_ parent: Heatmap) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.center = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if (annotation is MKPointAnnotation) {
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "hive")
                let image = UIImage(named: "map_grid")
                annotationView.image = image
                return annotationView
            }
            return nil
        }
        
    }
    
    
     
}

struct TrailMapView_Previews: PreviewProvider {
    static var previews: some View {
        TrailMapView(spots: [SecretSpot.spot])
    }
}
