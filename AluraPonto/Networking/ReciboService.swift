//
//  ReciboService.swift
//  AluraPonto
//
//  Created by Jose Luis Damaren Junior on 23/04/23.
//

import Foundation
import Alamofire

class ReciboService {
    func delete(id: String, completion: @escaping() -> Void) {
        AF.request("http://localhost:8080/recibos/\(id)", method: .delete, headers: ["Accept": "application/json"]).responseData(completionHandler: { _ in
            completion()
        })
    }
    
    func get(completion: @escaping(_ recibos: [Recibo]?, _ error: Error?) -> Void) {
        AF.request("http://localhost:8080/recibos", method: .get, headers: ["Accept": "application/json"]).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let json):
                var recibos: [Recibo] = []
                if let listaDeRecibos = json as? [[String: Any]] {
                    print(listaDeRecibos)
                    for reciboDict in listaDeRecibos {
                        if let newRecibo = Recibo.serializa(reciboDict) {
                            recibos.append(newRecibo)
                        }
                    }
                    completion(recibos, nil)
                }
                break
            case .failure(let error):
                completion(nil, error)
                break
            }
        })
    }
    
    func post(_ recibo: Recibo, completion: @escaping(_ isSaved: Bool) -> Void) {
        let baseURL = "http://localhost:8080/"
        let path = "recibos"
        
        let params: [String: Any] = [
            "data": FormatadorDeData().getData(recibo.data),
            "status": recibo.status,
            "localizacao": [
                "latitude": recibo.latitude,
                "longitude": recibo.longitude
            ]
        ]
        
        guard let body = try? JSONSerialization.data(withJSONObject: params) else { return }
        
        guard let url = URL(string: baseURL + path) else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if error == nil {
                completion(true)
                return
            } else {
                completion(false)
            }
        }).resume()
        
    }
}
