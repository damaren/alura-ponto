//
//  HomeViewController.swift
//  Alura Ponto
//
//  Created by Ândriu Felipe Coelho on 22/09/21.
//

import UIKit
import CoreData
import CoreLocation

class HomeViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var horarioView: UIView!
    @IBOutlet weak var horarioLabel: UILabel!
    @IBOutlet weak var registrarButton: UIButton!

    // MARK: - Attributes
    
    private var timer: Timer?
    private lazy var camera = Camera()
    private lazy var controladorDeImage = UIImagePickerController()
    
    var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    lazy var locationManager = CLLocationManager()
    private lazy var location = Location()
    private lazy var reciboService = ReciboService()
    
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuraView()
        atualizaHorario()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configuraTimer()
        requestUserLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    // MARK: - Class methods
    
    func configuraView() {
        configuraBotaoRegistrar()
        configuraHorarioView()
    }
    
    func configuraBotaoRegistrar() {
        registrarButton.layer.cornerRadius = 5
    }
    
    func configuraHorarioView() {
        horarioView.backgroundColor = .white
        horarioView.layer.borderWidth = 3
        horarioView.layer.borderColor = UIColor.systemGray.cgColor
        horarioView.layer.cornerRadius = horarioView.layer.frame.height/2
    }
    
    func configuraTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(atualizaHorario), userInfo: nil, repeats: true)
    }
    
    @objc func atualizaHorario() {
        let horarioAtual = FormatadorDeData().getHorario(Date())
        horarioLabel.text = horarioAtual
    }
    
    func tentaAbrirCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            camera.delegate = self
            camera.abrirCamera(self, controladorDeImage)
        }
    }
    
    func requestUserLocation() {
        location.delegate = self
        location.askPermission(locationManager)
    }
    
    // MARK: - IBActions
    
    @IBAction func registrarButton(_ sender: UIButton) {
//        tentaAbrirCamera()
        let recibo = Recibo(status: false, data: Date(), foto: UIImage(), latitude: latitude ?? 0, longitude: longitude ?? 0)
        recibo.save(context)
        
        reciboService.post(recibo, completion: { [weak self] salvo in
            if !salvo {
                guard let context = self?.context else { return }
                recibo.save(context)
            }
        })
    }
}

extension HomeViewController: CameraDelegate {
    func didSelectFoto(_ image: UIImage) {
//        let recibo = Recibo(status: false, data: Date(), foto: image, latitude: latitude ?? 0, longitude: longitude ?? 0)
//        recibo.save(context)
//
//        let reciboService = ReciboService()
//        reciboService.post(recibo)
    }
}

extension HomeViewController: LocationDelegate {
    func updateUserLocation(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

