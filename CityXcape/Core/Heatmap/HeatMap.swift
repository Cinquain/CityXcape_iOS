//
//  HeatMap.swift
//  CityXcape
//
//  Created by James Allan on 7/30/22.
//

import SwiftUI
import UIKit
import MapKit

struct HeatMap: View {
    let vm: MyWorldViewModel
    var body: some View {
        ZStack {
            HeatMapView(vm: vm)
                .colorScheme(.dark)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
}


struct HeatMapView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    let mapView = MKMapView()
    let vm: MyWorldViewModel
    var center: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        if vm.annotations.count > 0 {
            uiView.removeAnnotations(uiView.annotations)
            vm.annotations.forEach { annotation in
                uiView.addAnnotation(annotation)
            }
            
            uiView.showAnnotations(uiView.annotations.filter({$0 is MKPointAnnotation}), animated: true)
            setupRegion()
        }
       
    }
    
    func setupRegion() {
        let orderedSpots = vm.currentSpots.sorted(by: {$0.distanceFromUser < $1.distanceFromUser})
        guard let firstSpot = orderedSpots.first else {return}
        let center = CLLocationCoordinate2D(latitude: firstSpot.latitude, longitude: firstSpot.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: HeatMapView
        
        init(_ parent: HeatMapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.center = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let image = UIImage(named: "grid")!
            let targetSize = CGSize(width: 50, height: 50)
            let targetHeight = targetSize.height / image.size.height
            let targetWidth = targetSize.width / image.size.width
            let scaleFactor = min(targetWidth, targetHeight)
            let scaleImageSize = CGSize(width: image.size.width * scaleFactor, height: image.size.height * scaleFactor)
            let renderer =  UIGraphicsImageRenderer(size: scaleImageSize)
            let scaledImage = renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: scaleImageSize))
            }
            if (annotation is MKPointAnnotation) {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "hex")
                view.image = scaledImage
                return view
            }
            return nil
        }
        //End of Coordinator
    }
    
    
    //End of HeatMapView
}



struct HeatMapView_Previews: PreviewProvider {
    static var previews: some View {
        HeatMap(vm: MyWorldViewModel())
    }
}

