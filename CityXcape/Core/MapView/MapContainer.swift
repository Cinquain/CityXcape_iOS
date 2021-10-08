//
//  MapView.swift
//  CityXcape
//
//  Created by James Allan on 8/21/21.
//

import SwiftUI
import MapKit
import UIKit

struct MapContainer: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var vm = MapSearchViewModel()
    @State private var showForm: Bool = false
    @State private var opacity: Double = 0
    @State private var refresh: Bool = false
    @State var isMission: Bool
    
    @State var mapItem: MKMapItem = MKMapItem()
    
    var body: some View {
        
        ZStack(alignment: .top) {
            MapView(selectedMapItem: vm.selectedMapItem, currentLocation: vm.currentLocation, annotations: vm.annotations)
        
            
            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    TextField("Search Location", text: $vm.searchQuery, onCommit: {
                        UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.endEditing(true)
                        opacity = 0
                    })
                        .padding()
                        .background(Color.white)
                        .cornerRadius(3)
                        .foregroundColor(.black)
                    .accentColor(.black)
                }
                .padding()
                .padding(.vertical,20)
                .foregroundColor(.black)
                
                
                ScrollView(.vertical) {
                    VStack(spacing: 16) {
                        
                        ForEach(vm.mapItems, id: \.self) { mapItem in
                            
                            Button(action: {

                                vm.selectedMapItem = mapItem
                                self.mapItem = mapItem
                                withAnimation {
                                    opacity = 1
                                }
                                
                            }, label: {
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(mapItem.name ?? "")
                                        .font(.headline)
                                    Text(mapItem.placemark.title ?? "")
                                }
                            })
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                      
                    }
                    .animation(.easeOut(duration: 0.5))
                    .padding(.horizontal, 16)
                }
                .shadow(radius: 5)
                .frame(maxHeight: 300)
                
                Spacer()
                
                Button(action: {
                    showForm.toggle()
                }, label: {
                    HStack {
                        Image("marker")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        Text("Fill Out Details")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(5)

                       
                })
                .padding()
                .animation(.easeOut(duration: 0.5))
                .opacity(opacity)
             
                Spacer()
                    .frame(height: vm.keyboardHeight)

            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showForm, onDismiss: {
            withAnimation {
                opacity = 0
                self.isMission = false
            }
        }, content: {
            CreateSpotFormView(opacity: $opacity, mapItem: mapItem)
        })
       
      
        

    }
    
}

struct MapView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    let mapView = MKMapView()
   
    var centerCoordinate: CLLocationCoordinate2D?
    var selectedMapItem: MKMapItem?
    var currentLocation: CLLocationCoordinate2D?
    
    
    var annotations: [MKPointAnnotation]
    @State var gestureAnnotation: MKPointAnnotation?
    
    func makeUIView(context: Context) -> MKMapView {
        setupRegionForMap()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        let longPressed = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.addPinBasedOnGesture(_:)))
        longPressed.minimumPressDuration = 3
        mapView.addGestureRecognizer(longPressed)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        uiView.delegate = context.coordinator
       
//        if let pressedAnnotion = gestureAnnotation {
//            uiView.addAnnotation(pressedAnnotion)
//            return
//        }
        if annotations.count == 0 {
            uiView.removeAnnotations(uiView.annotations)
            if let location = currentLocation {
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: location, span: span)
                uiView.setRegion(region, animated: true)
            }
            
            return
        }
        
      
        
        uiView.removeAnnotations(uiView.annotations)
        annotations.forEach { annotation in
            uiView.addAnnotation(annotation)
        }
        uiView.showAnnotations(uiView.annotations.filter({$0 is MKPointAnnotation}), animated: true)
        
      
        
        uiView.annotations.forEach { annotation in
            if annotation.title == selectedMapItem?.name {
                uiView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    
    typealias UIViewType = MKMapView
    
    
    fileprivate func setupRegionForMap() {
        guard let location = currentLocation else {return}
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if (annotation is MKPointAnnotation) {
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "id")
                annotationView.canShowCallout = true
                let image = UIImage(named: "marker")
                annotationView.image = image
                return annotationView
            }
            return nil
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            
            NotificationCenter.default.post(name: MapView.Coordinator.regionChangedNofication, object: mapView.region)
            
        }
        
        static let regionChangedNofication = NSNotification.Name(rawValue: "regionChangedNotification")
        
        
        @objc func addPinBasedOnGesture(_ gestureRecognizer: UIGestureRecognizer) {
            print("Pressing long gesture")
            let touchPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            let newCoordinates = (gestureRecognizer.view as? MKMapView)?.convert(touchPoint, toCoordinateFrom: gestureRecognizer.view)
            let annotation = MKPointAnnotation()
            guard let newCoordinate = newCoordinates else {return}
            annotation.coordinate = newCoordinate
            parent.gestureAnnotation = annotation
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapContainer(isMission: false)
            .colorScheme(.dark)
    }
}
