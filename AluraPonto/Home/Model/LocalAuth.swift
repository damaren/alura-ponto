//
//  LocalAuth.swift
//  AluraPonto
//
//  Created by Jose Luis Damaren Junior on 21/04/23.
//

import Foundation
import LocalAuthentication

class LocalAuth {
    private let authContext = LAContext()
    private var error: NSError?
    
    func authUser(completion: @escaping(_ auth: Bool) -> Void) {
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "É necessário autenticação para apagar um recibo", reply: { [weak self] success, error in
                completion(success)
            })
        }
    }
}
