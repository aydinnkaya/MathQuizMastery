//
//  RegisterScreenViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation
import CoreData
import UIKit

// MARK: - Register Screen View Model Delegate
protocol RegisterScreenViewModelDelegate : AnyObject{
    func registrationSucceeded()
    func registrationFailed(_ error : Error )
}

// MARK: - Register Screen View Model
final class RegisterScreenViewModel : RegisterScreenViewModelProtocol {
    private let coreDataManger : CoreDataServiceProtocol
    weak var delegate : RegisterScreenViewModelDelegate?
    
    init(coreDataManger : CoreDataServiceProtocol = CoreDataManager()) {
        self.coreDataManger = coreDataManger
    }
    
    func savePerson(name: String, email: String, password: String){
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            let error = NSError(domain: "com.mathquizmastery.registration", code: 1001, userInfo:  [NSLocalizedDescriptionKey: "Lütfen tüm alanları doldurunuz"])
            delegate?.registrationFailed(error)
            return
        }
        
        coreDataManger.saveUser(name: name, email: email, password: password, completion: { result in
            switch result {
            case .success() :
                DispatchQueue.main.async {
                    self.delegate?.registrationSucceeded()
                }
            case .failure(let error):
                let userFriendlyError = NSError(
                    domain: "com.mathquizmastery.registration",
                    code: 1002,
                    userInfo: [NSLocalizedDescriptionKey: "Kayıt sırasında bir hata oluştu. Lütfen tekrar deneyiniz.\n(\(error.localizedDescription))"]
                )
                DispatchQueue.main.async {
                    self.delegate?.registrationFailed(userFriendlyError)
                }
            }
            
        })
    }
    
    func validateEmail(_ email: String) -> ValidationResult {
        if email.isEmpty {
            return .invalid(L(.field_required))
        } else if !email.contains("@") {
            return .invalid(L(.invalid_email))
        }
        return .valid
    }

    func validPassword(_ password : String) -> ValidationResult{
        if password.isEmpty{
            return .invalid(L(.enter_password))
        }
        return .valid
    }
    
    
    
}
