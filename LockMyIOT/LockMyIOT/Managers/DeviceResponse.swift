//
//  DeviceManager.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 24/12/2024.
//

import SwiftUI

struct Device: Decodable, Identifiable {
    let id: String
    let name: String
    let type: DeviceType
    let ipAddress: String
    let status: DeviceStatus
}

enum DeviceStatus: String, Decodable {
    case secure = "Secure"
    case unsecure = "Unsecure"
    
    enum CodingKeys: String, CodingKey {
        case secure = "SECURE"
        case unsecure = "unsecure"
    }
    
    var color: Color {
        switch self {
        case .secure:
                .statusGreen
        case .unsecure:
                .red
        }
    }
}

enum DeviceType: String, Decodable {
    case phone = "PHONE"
    case speaker = "SPEAKER"
    case other = "OTHER"
    
    var icon: String {
        switch self {
        case .phone:
            "iphone"
        case .speaker:
            "homepod.mini.badge.plus.fill"
        case .other:
            "globe"
        }
    }
}
