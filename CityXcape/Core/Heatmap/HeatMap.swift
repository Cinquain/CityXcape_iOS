//
//  HeatMap.swift
//  CityXcape
//
//  Created by James Allan on 7/30/22.
//

import SwiftUI
import UIKit
import MapboxMaps
import MapKit

class HeatMap: UIViewController {
    
    internal var mapView: MapView!
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        let resourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoiY2lucXVhaW4iLCJhIjoiY2lnZGRhem56MXAydHY5bTJrcTBqNnk2cSJ9.D_6TLzB1kL7KQRLMJtosIg")
        let style = StyleURI(rawValue: "mapbox://styles/cinquain/cjzvggg2d14uc1coae4u1c3vr")
        let longitude = LocationService.instance.userlocation?.longitude ?? 0
        let latitude = LocationService.instance.userlocation?.latitude ?? 0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let cameraOptions = CameraOptions(center: coordinate, zoom: 13)
        let initOptions = MapInitOptions(resourceOptions: resourceOptions, cameraOptions: cameraOptions, styleURI: style)
        mapView = MapView(frame: view.bounds, mapInitOptions: initOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)

    }
    
}


struct HeatMapView: UIViewControllerRepresentable {
    
    let vm: MyWorldViewModel
    
    func makeUIViewController(context: Context) -> HeatMap {
        return HeatMap()
    }
    
    func updateUIViewController(_ uiViewController: HeatMap, context: Context) {
       
        let manager = uiViewController
                        .mapView.annotations.makePointAnnotationManager()
        manager.annotations = vm.annotations
       
    }
}



struct HeatMapView_Previews: PreviewProvider {
    static var previews: some View {
        HeatMapView(vm: MyWorldViewModel())
            .edgesIgnoringSafeArea(.all)
    }
}

