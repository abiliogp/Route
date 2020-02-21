//
//  MapViewController.swift
//  route
//
//  Created by Abilio Gambim Parada on 21/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    private var mapTripViewModel: MapTripViewModel!

    static func makeMapViewController(mapTripViewModel: MapTripViewModel) -> MapViewController? {

        if let mapViewController = UIStoryboard(name: Keys.Storyboard.main, bundle: nil)
            .instantiateViewController(withIdentifier: Keys.MapViewController.identifier) as? MapViewController {

            mapViewController.mapTripViewModel = mapTripViewModel

            return mapViewController
        }

        return nil
    }

    override func viewDidLoad() {
        title = NSLocalizedString(Keys.MapViewController.titleMap,
                                  comment: Keys.MapViewController.titleMap)

        setupBinding()
        mapTripViewModel.setupController()
    }

    func setupBinding() {

        mapTripViewModel.onMapReady = { [weak self] (mapTripList) in
            guard let self = self else { return }

            var source = true

            var step = 1
            mapTripList.forEach { (mapTrip) in
                if let latDouble = Double(mapTrip.lat),
                    let longDouble = Double(mapTrip.long) {

                    let point = self.createPoint(lat: latDouble,
                                                 long: longDouble,
                                                 title: "\(step):\(mapTrip.name)")

                    step += 1
                    self.mapView.addAnnotation(point)

                    source.toggle()
                }
            }

            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }

    private func createPoint(lat: Double, long: Double, title: String) -> MKPointAnnotation {
        let sourceLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = title

        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }

        return sourceAnnotation
    }

}
