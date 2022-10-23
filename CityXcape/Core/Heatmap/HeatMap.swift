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
    @Environment(\.presentationMode) var presentationMode

    var vm: WorldViewModel
    @State var currentUser: User?
    var body: some View {
        ZStack {
            
            HeatMapView(user: $currentUser, vm: vm)
                .colorScheme(.dark)
                .sheet(item: $currentUser) { user in
                    PublicStreetPass(user: user)
                }
            
            VStack {
                InfoBanner()
                    .padding(.top, 40)
                
                Spacer()
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .opacity(0.5)
                }
                .padding()
            }
            
        }
        .edgesIgnoringSafeArea(.all)

    }
    
}


struct HeatMapView: UIViewRepresentable {
    @Binding var user: User?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    let mapView = MKMapView()
    @StateObject var vm: WorldViewModel
    var center: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        if vm.users.count > 0 {
            uiView.removeAnnotations(uiView.annotations)
            vm.annotations.forEach { annotation in
                uiView.addAnnotation(annotation)
            }
            
            uiView.showAnnotations(uiView.annotations.filter({$0 is MKPointAnnotation}), animated: true)
        }
    }
    
    func setupRegion() {
        let orderedSpots = vm.users.sorted(by: {$0.distanceFromUser < $1.distanceFromUser})
        guard let firstSpot = orderedSpots.first else {return}
        let center = CLLocationCoordinate2D(latitude: firstSpot.latitude ?? 0, longitude: firstSpot.longitude ?? 0)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
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
            
            if (annotation is MKPointAnnotation) {
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "id")
                annotationView.canShowCallout = true
                let image = UIImage(named: "world_dot")
                annotationView.image = image
                return annotationView
            }
            return nil
        }
        
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            let title = view.annotation?.title ?? ""
            let selectedUser = parent.vm.users.first(where: {$0.displayName == title})
            if let user = selectedUser {
                parent.user = user
            }
        }
        //End of Coordinator
    }
    
    
    //End of HeatMapView
}



struct HeatMapView_Previews: PreviewProvider {
    static var previews: some View {
        HeatMap(vm: WorldViewModel())
    }
}

