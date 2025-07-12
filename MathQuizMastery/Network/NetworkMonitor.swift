//
//  NetworkMonitor.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 12.07.2025.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var isConnected: Bool = true
    var onStatusChange: ((Bool) -> Void)?

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let connected = path.status == .satisfied
            if connected != self.isConnected {
                self.isConnected = connected
                DispatchQueue.main.async {
                    print("📡 Network status changed: \(connected ? "Connected" : "Disconnected")")
                    self.onStatusChange?(connected)
                }
            }
        }
        monitor.start(queue: queue)
    }
}
