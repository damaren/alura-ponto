//
//  Camera.swift
//  AluraPonto
//
//  Created by Jose Luis Damaren Junior on 20/04/23.
//

import Foundation
import UIKit

protocol CameraDelegate: AnyObject {
    func didSelectFoto(_ image: UIImage)
}

class Camera: NSObject {
    
    weak var delegate: CameraDelegate?
    
    func abrirCamera(_ controller: UIViewController, _ imagePicker: UIImagePickerController) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.front) ? .front : .rear
        
        controller.present(imagePicker, animated: true)
    }
    
    func abrirBibliotecaDeFotos(_ controller: UIViewController, _ imagePicker: UIImagePickerController) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        controller.present(imagePicker, animated: true)
    }
}

extension Camera: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let foto = info[.editedImage] as? UIImage else { return }
        delegate?.didSelectFoto(foto)
    }
}
