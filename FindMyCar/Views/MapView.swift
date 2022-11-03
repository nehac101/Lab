//
//  MapView.swift
//  FindMyCar
//
//  Created by Neha Choudhari on 11/1/22.
//  Copyright © 2022 Steph K. Ananth. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
  let viewController: ViewController
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
    self.viewController.carLocation.loadLocation()
    let coordinate = CLLocationCoordinate2D(latitude: viewController.carLocation.latitude, longitude: viewController.carLocation.longitude
    )
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    uiView.showsUserLocation = true
    uiView.setRegion(region, animated: true)
  }

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView(frame: .zero)
    let droppedPin = MKPointAnnotation()
    self.viewController.carLocation.loadLocation()

    droppedPin.coordinate = CLLocationCoordinate2D(
      latitude: self.viewController.carLocation.latitude ,
      longitude: self.viewController.carLocation.longitude
    )
    
    droppedPin.title = "You are Here"
    droppedPin.subtitle = "Look it's you!"
    mapView.addAnnotation(droppedPin)
    return mapView
  }
  
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
      MapView(viewController: ViewController())
    }
}
