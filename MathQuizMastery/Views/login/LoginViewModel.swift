//
//  LoginViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation

// MARK: - Delegate Login View Model
protocol LoginViewModelDelegate : AnyObject {
    func didLoginSuccessfuly()
    func didFailWithError(_ error : Error )
}


final class LoginViewModel : LoginScreenViewModelProtocol {
    
    weak var delegate : LoginViewModelDelegate?
    
    func login(email: String, password: String){
        guard !email.isEmpty, !password.isEmpty else {
            let error = NSError(domain: "Hata", code: 401, userInfo: [NSLocalizedDescriptionKey: "Boş alanları doldurunuz"])
            delegate?.didFailWithError(error)
            return
        }
        
        CoreDataManager.shared.fetchUser(email: email, password: password, completion: { result in
            switch result{
            case .success(let user) :
                if let _ = user{
                    DispatchQueue.main.async {
                        self.delegate?.didLoginSuccessfuly()
                    }
                }else {
                    let error = NSError(domain: "Giriş hatası", code: 403, userInfo: [NSLocalizedDescriptionKey: "Geçersiz e-posta veya şifre"])
                    DispatchQueue.main.async {
                        self.delegate?.didFailWithError(error)
                    }
                }
                
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error)
                }
            }
        })
    }
    
}
