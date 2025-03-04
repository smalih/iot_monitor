//
//  DeviceModels.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 24/12/2024.
//

import Foundation

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
        self.type = try container.decode(DeviceType.self, forKey: .type)
        self.ipAddress = try container.decode(String.self, forKey: .ipAddress)
//        self.macAddress = try container.decode(String.sefl, forKey: .macAddress)
        self.status = try container.decode(DeviceStatus.self, forKey: .status)
    }
}




extension Device {
    static let standard = Device(id: 123, name: "iPhone 12", type: .phone, ipAddress: "192.168.0.1", status: .secure)
}
