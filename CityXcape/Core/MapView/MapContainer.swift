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
    
    @Binding var selectedTab: Int
    @State var isHunt: Bool = false
    
    @ObservedObject var vm = MapSearchViewModel()
    @State var mapItem: MKMapItem = MKMapItem()
    
    var body: some View {
        
        ZStack(alignment: .top) {
            MapView(viewModel: vm)
                
            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    TextField("Search Location", text: $vm.searchQuery, onCommit: {
                        UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.endEditing(true)

                    })
                        .placeholder(when: vm.searchQuery.isEmpty) {
                            Text("Search address or tap to drop pin").foregroundColor(.gray)
                    }
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
                                isHunt ? vm.showTrailForm.toggle() : vm.showForm.toggle()
                                
                            }, label: {
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(mapItem.name ?? "Coordinate Location")
                                        .font(.headline)
                                    Text(mapItem.placemark.title ?? mapItem.getAddress())
                                        .font(.caption)
                                    Text("Tap to fillout details")
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
                

                
                HStack {
                    
//                    Button {
//                        vm.showActionSheet.toggle()
//                    } label: {
//                        Image("trail")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 45)
//                    }
//                    .fullScreenCover(isPresented: $vm.showTrailForm) {
//                        isHunt = false
//                    } content: {
//                        PostTrailForm(isHunt: $isHunt, mapItem: mapItem)
//                    }


                    Button(action: {
                        vm.searchQuery = ""
                    }, label: {
                        HStack {
                            Image("marker")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                            Text("Clear Map")
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
                    .opacity(vm.mapItems.count >= 1 ? 1 : 0)
                    

                        
                        Button {
                            AnalyticsService.instance.droppedPin()
                            vm.dropPin()
                        } label: {
                            Image("Post Pin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45)
                        }
                    .opacity(vm.mapItems.count >= 1 ? 0 : 1)
                        
                    

                }
                .padding(.horizontal, 15)

                Spacer()
                    .frame(height: 50)
             
                Spacer()
                    .frame(height: vm.keyboardHeight)

            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $vm.showForm, onDismiss: {
            withAnimation {
                
            }
        }, content: {
            PostSpotForm(selectedTab: $selectedTab, mapItem: mapItem)

        })
        .actionSheet(isPresented: $vm.showActionSheet) {
            return ActionSheet(title: Text("What type of trail is this?"), message: nil, buttons: [
                
            .default(Text("Normal Trail"), action: {
                vm.showTrailForm.toggle()
            }),
            
            .default(Text("Scavenger Hunt"), action: {
                isHunt = true
                vm.alertMessgae = "Start by choosing a starting location"
                vm.showAlert.toggle()
            }),
            
            .cancel()
        ])
        }
        .alert(isPresented: $vm.showAlert) {
            return Alert(title: Text(vm.alertMessgae))
        }
        

    }
    
}

struct MapView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    let mapView = MKMapView()
    var viewModel: MapSearchViewModel
    var centerCoordinate: CLLocationCoordinate2D?
    
    
    
    func makeUIView(context: Context) -> MKMapView {
        setupRegionForMap()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.addPinBasedOnGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(tapGesture)
        mapView.isUserInteractionEnabled = true
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        //User searches location
        if viewModel.annotations.count > 0 {
            uiView.removeAnnotations(uiView.annotations)
            viewModel.annotations.forEach { annotation in
                uiView.addAnnotation(annotation)
            }
                  
            uiView.showAnnotations(uiView.annotations.filter({$0 is MKPointAnnotation}), animated: true)
        }
        
        //User selects a pin
        uiView.annotations.forEach { annotation in
            if annotation.title == viewModel.selectedMapItem?.name {
                uiView.selectAnnotation(annotation, animated: true)
            }
        }

        
   
        //User finished posting a spot
        if viewModel.spotComplete == true {
            uiView.removeAnnotations(uiView.annotations)
            viewModel.spotComplete.toggle()
        }
        
        //User resets the search
        if viewModel.annotations.count == 0 && viewModel.isSearching {
            uiView.removeAnnotations(uiView.annotations)
            if let location = viewModel.currentLocation {
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: location, span: span)
                uiView.setRegion(region, animated: true)
            }
            
            return
        }
        
        
  
        
    }
    
    typealias UIViewType = MKMapView
    
    fileprivate func setupRegionForMap() {
        guard let location = viewModel.currentLocation else {return}
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
            AnalyticsService.instance.droppedPin()
            annotation.coordinate = newCoordinate
            let addedPlacemark = MKPlacemark(coordinate: newCoordinate)
            let mapItem = MKMapItem(placemark: addedPlacemark)
            parent.viewModel.mapItems.append(mapItem)
            parent.viewModel.annotations.append(annotation)
            
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    @State static var isSelected: Int = 0
    static var previews: some View {
        MapContainer(selectedTab: $isSelected)
            .colorScheme(.dark)
    }
}
