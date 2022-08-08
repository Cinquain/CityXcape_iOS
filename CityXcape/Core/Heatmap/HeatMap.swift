//
//  HeatMap.swift
//  CityXcape
//
//  Created by James Allan on 7/30/22.
//

import SwiftUI
import UIKit
import Shimmer
import MapboxMaps
import MapboxCommon

class HeatMap: UIViewController {
    
    internal var mapView: MapView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let resourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoiY2lucXVhaW4iLCJhIjoiY2lnZGRhem56MXAydHY5bTJrcTBqNnk2cSJ9.D_6TLzB1kL7KQRLMJtosIg")
        let style = StyleURI(rawValue: "mapbox://styles/cinquain/cjzvggg2d14uc1coae4u1c3vr")
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: 40.760491, longitude: -73.980928), zoom: 13)

        let initOptions = MapInitOptions(resourceOptions: resourceOptions, cameraOptions: cameraOptions, styleURI: style)
        mapView = MapView(frame: view.bounds, mapInitOptions: initOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        
        var union = PointAnnotation(coordinate: .init(latitude: 40.7349039, longitude: -73.9917527))
        var soho = PointAnnotation(coordinate: .init(latitude: 40.7209126, longitude: -74.0024305))
        var loE = PointAnnotation(coordinate: .init(latitude: 40.7154431, longitude: -73.9844130))
        var chelsea = PointAnnotation(coordinate: .init(latitude: 40.7467416, longitude: -74.0025880))
        let center = mapView.cameraState.center
        
        let manager = mapView.annotations.makePointAnnotationManager()
        var annotation = PointAnnotation(coordinate: center)
        let image = UIImage(named: "grid")!
        let targetSize = CGSize(width: 100, height: 100)
        let targetHeight = targetSize.height / image.size.height
        let targetWidth = targetSize.width / image.size.width
        let scaleFactor = min(targetWidth, targetHeight)
        let scaleImageSize = CGSize(width: image.size.width * scaleFactor, height: image.size.height * scaleFactor)
        let renderer =  UIGraphicsImageRenderer(size: scaleImageSize)
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaleImageSize))
        }
        annotation.image = .init(image: scaledImage, name: "grid")
        union.image = .init(image: scaledImage, name: "grid")
        soho.image = .init(image: scaledImage, name: "grid")
        loE.image = .init(image: scaledImage, name: "grid")
        chelsea.image = .init(image: scaledImage, name: "grid")
        manager.annotations = [annotation, union, soho, loE, chelsea]
    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.orange.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = scaledImage.accessibilityFrame
        let angle = 45 * CGFloat.pi / 180
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.fromValue = -view.frame.width
        animation.toValue = view.frame.width
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "animation")
    }
}


struct HeatMapView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HeatMap {
        return HeatMap()
    }
    
    func updateUIViewController(_ uiViewController: HeatMap, context: Context) {
        //
    }
}



struct HeatMapView_Previews: PreviewProvider {
    static var previews: some View {
        HeatMapView()
            .edgesIgnoringSafeArea(.all)
    }
}

