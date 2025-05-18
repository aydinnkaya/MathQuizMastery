//
//  HomeViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 30.04.2025.
//

import Foundation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    func notifyViewDidLoad()
    func playButtonTapped()
}

protocol HomeViewModelDelegate: AnyObject {
    func didReceiveUser(_ user: User?)
    func navigateToCategory()
}

class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    private(set) var user: User
    private let authService: AuthServiceProtocol
    
    init(user: User, authService: AuthServiceProtocol = AuthService.shared) {
        self.user = user
        self.authService = authService
    }
    
    func notifyViewDidLoad() {
        delegate?.didReceiveUser(user)
    }
    
    func playButtonTapped() {
        
    }
}
