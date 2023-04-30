//
//  MapViewController.swift
//  AluraPonto
//
//  Created by Jose Luis Damaren Junior on 22/04/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var map: MKMapView!
    
    // MARK: - Attributes
    
    private var recibo: Recibo?
    
    class func instanciar(_ recibo: Recibo?) -> MapViewController {
        let controller = MapViewController(nibName: "MapViewController", bundle: nil)
        controller.recibo = recibo
        
        return controller
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setRegion()
        addPin()
    }
    
    // MARK: - Methods
    
    func setRegion() {
        guard let latitude = recibo?.latitude, let longitude = recibo?.longitude else {
            return
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let regiao = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
        
        map.setRegion(regiao, animated: true)
    }
    
    func addPin() {
        let annotation = MKPointAnnotation()
        annotation.title = "Registro de Ponto"
        
        annotation.coordinate.latitude = recibo?.latitude ?? 0
        annotation.coordinate.longitude = recibo?.longitude ?? 0
        
        map.addAnnotation(annotation)
    }
    
}
