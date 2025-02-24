//
//  DeviceManager.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 24/12/2024.
//

import SwiftUI

struct Device: Decodable, Identifiable {
    let id: Int
    let name: String
    let type: DeviceType
    let ipAddress: String
//    let macAddress: String
    let status: DeviceStatus
    
    enum CodingKeys: String, CodingKey {
        case id 
        case name
        case type
        case ipAddress = "ip_addr"
//        case macAddress = "mac_addr"
        case status
    
    }
    
    init(id: Int, name: String, type: DeviceType, ipAddress: String, status: DeviceStatus) {
        self.id = id
        self.name = name
        self.type = type
        self.ipAddress = ipAddress
        self.status = status
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = .phone
        self.ipAddress = "192.168.0.1"
        self.status = .secure
    }
}

enum DeviceStatus: String, Decodable {
    case secure = "Secure"
    case unsecure = "Unsecure"
    
    enum CodingKeys: String, CodingKey {
        case secure = "SECURE"
        case unsecure = "UNSECURE"
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
