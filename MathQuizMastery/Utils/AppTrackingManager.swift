//
//  AppTrackingManager.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 25.06.2025.
//

import Foundation
import AppTrackingTransparency
import AdSupport

final class AppTrackingManager {
    
    static func requestTrackingAuthorizationIfNeeded() {
        guard #available(iOS 14, *) else { return }
        
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("✅ Tracking authorized - IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
            case .denied:
                print("❌ Tracking denied")
            case .restricted:
                print("🚫 Tracking restricted")
            case .notDetermined:
                print("🤔 Tracking not determined")
            @unknown default:
                print("⚠️ Unknown tracking status")
            }
        }
    }
}
