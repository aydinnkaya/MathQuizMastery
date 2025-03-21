//
//  RegisterScreenViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation
import CoreData
import UIKit


protocol RegisterScreenViewModelDelegate{
    
}


class RegisterScreenViewModel : RegisterScreenViewModelProtocol {
    
    
    func savePerson(name: String, email: String, password: String){
        
        // early exit
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        // Created person object
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)!
        let person = NSManagedObject(entity: entity, insertInto: context)
        
        person.setValue(name, forKey: "name")
        person.setValue(email, forKey: "email")
        person.setValue(password, forKey:"password")
        
        do {
            try context.save()
            print("new user saved \(name)")

        }catch{
            print("Error: not save")
        }
    }
    
}
