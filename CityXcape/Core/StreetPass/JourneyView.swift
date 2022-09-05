//
//  JourneyView.swift
//  CityXcape
//
//  Created by James Allan on 3/2/22.
//

import SwiftUI
import MapKit

struct JourneyView: View {
    @Environment(\.presentationMode) var presentationMode
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
                    UserDotView(imageUrl: profileUrl ?? "", width: 80)
                    Text(displayName ?? "")
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                   
                        Text("My Journey")
                        .font(Font.custom("Lato", size: 35))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if vm.showCollection {
                StampCollectionView(vm: vm)
                    .animation(.easeOut(duration: 0.5))
            } else {
                
                JourneyMap(vm: vm, verifications: vm.verifications)
                    .frame(width: width, height: height)
                    .colorScheme(.dark)
                    .cornerRadius(5)
            }
       
            Spacer()
                .frame(height: width * 0.15)
           
            HStack(alignment: .center){
                
                VStack(alignment: .leading) {
                    
                    Button {
                        //TBD
                        vm.showCollection = false
                    } label: {
                        
                        HStack {
                            
                        Image("pin_blue")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                                
                            Text(vm.locationMessage())
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                            .frame(width: 100, height: 50, alignment: .leading)
                        }
                    }
                    .sheet(item: $vm.verification) { verification in
                        PublicStampView(verification: verification)
                    }

                    Button {
                        //TBD
                        vm.openCollection()
                    } label: {
                        HStack {
                            Image("city")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            
                            Text(vm.cityMessage())
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                            .frame(width: 100, height: 50, alignment: .leading)
                        }
                    }
                    

  
                    
                    Button {
                        //TBD
                        vm.openJournal()
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
                    .fullScreenCover(isPresented: $vm.showJournal) {
                        MyJournal(vm: vm)
                    }

                }
                //End of button HStack
            }
  
            Spacer()
            
            Button {
                //
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .opacity(0.5)
            }

            
            
       
        }
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
}

struct JourneyMap: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(mapview, vm)
    }
    
    let vm: JourneyViewModel
    let verifications: [Verification]
    let mapview = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapview.showsCompass = false
        mapview.isUserInteractionEnabled = true
        mapview.delegate = context.coordinator
        if verifications.isEmpty {return mapview}
        let annotations = verifications.map({MKPointAnnotation(__coordinate: .init(latitude: $0.latitude, longitude: $0.longitude))})
        mapview.addAnnotations(annotations)
        mapview.showAnnotations(mapview.annotations.filter({$0 is MKPointAnnotation}), animated: true)
        return mapview
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        if let selectionAnnotation = mapview.selectedAnnotations.first {
            let coordinates = selectionAnnotation.coordinate
            print("Coming from mapview", coordinates)
        }
        //TBD
        if verifications.isEmpty {return}
        uiView.removeAnnotations(mapview.annotations)
        let annotations = verifications.map({MKPointAnnotation(__coordinate: .init(latitude: $0.latitude, longitude: $0.longitude))})
        uiView.addAnnotations(annotations)
        uiView.showAnnotations(mapview.annotations.filter({$0 is MKPointAnnotation}), animated: true)
        
    }
    
    
    
    typealias UIViewType = MKMapView
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MKMapView
        var vm: JourneyViewModel
        init(_ parent: MKMapView, _ vm: JourneyViewModel) {
            self.parent = parent
            self.vm = vm
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
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            let annotation = view.annotation as? MKPointAnnotation
            let coordinates = annotation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
            if let object = vm.verifications.first(where: {$0.latitude == coordinates.latitude && $0.longitude == coordinates.longitude}) {
                vm.verification = object
            }
        }
        
    }
    
}



struct JourneyView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyView()
    }
}
