//
//  Perfil.swift
//  AluraPonto
//
//  Created by Jose Luis Damaren Junior on 21/04/23.
//

import Foundation
import UIKit

class Perfil {
    private let nomeDaFoto = "perfil.png"
    
    func salvarImagem(_ image: UIImage) {
        guard let diretorio = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let nomeDaFoto = "perfil.png"
        let urlDoArquivo = diretorio.appendingPathComponent(nomeDaFoto)
        
        if FileManager.default.fileExists(atPath: urlDoArquivo.path) {
            // remover a foto
            removeOldImage(urlDoArquivo)
        }
        
        guard let imagemData = image.jpegData(compressionQuality: 1) else { return }
        
        do {
            try imagemData.write(to: urlDoArquivo)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeOldImage(_ url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func loadImage() -> UIImage? {
        let dir = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        let fileUrl = NSSearchPathForDirectoriesInDomains(dir, userDomainMask, true)
        
        if let fileUrl = fileUrl.first {
            let completeImageUrl = URL(fileURLWithPath: fileUrl).appendingPathComponent(nomeDaFoto)
            
            let image = UIImage(contentsOfFile: completeImageUrl.path)
            return image
        }
        
        return UIImage(named: "")
    }
}
