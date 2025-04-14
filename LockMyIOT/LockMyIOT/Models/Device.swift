//
//  Device.swift
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
    let macAddress: String
    let status: DeviceStatus
    let message: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case ipAddress = "ip_addr"
        case macAddress = "mac_addr"
        case status
        case message
    }

    init(id: Int, name: String, type: DeviceType, ipAddress: String, macAddress: String, status: DeviceStatus, message: String = "") {
        self.id = id
        self.name = name
        self.type = type
        self.ipAddress = ipAddress
        self.macAddress = macAddress
        self.status = status
        self.message = message
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(DeviceType.self, forKey: .type)
        self.ipAddress = try container.decode(String.self, forKey: .ipAddress)
        self.macAddress = try container.decode(String.self, forKey: .macAddress)
        self.status = try container.decode(DeviceStatus.self, forKey: .status)
        self.message = try container.decode(String.self, forKey: .message)
    }
}

extension Device {
    static let standard = Device(id: 1, name: "iPhone 15", type: .phone, ipAddress: "192.168.1.10", macAddress: "00:1A:2B:3C:4D:5E", status: .secure)

    static let mockDevices: [Device] = [
        Device(id: 1, name: "iPhone 15", type: .phone, ipAddress: "192.168.1.10", macAddress: "00:1A:2B:3C:4D:5E", status: .secure),
        Device(id: 2, name: "Google Home", type: .speaker, ipAddress: "192.168.1.20", macAddress: "00:1B:2C:3D:4E:5F", status: .secure),
        Device(id: 3, name: "Unknown Device", type: .other, ipAddress: "192.168.1.30", macAddress: "00:1C:2D:3E:4F:5A", status: .unsecure, message: "DEVICE UNSECURE"),
        Device(id: 4, name: "MacBook Pro", type: .phone, ipAddress: "192.168.1.40", macAddress: "00:1D:2E:3F:4A:5B", status: .secure),
        Device(id: 5, name: "Amazon Echo", type: .speaker, ipAddress: "192.168.1.50", macAddress: "00:1E:2F:3A:4B:5C", status: .unsecure, message: "DEVICE UNSECURE"),
        Device(id: 6, name: "Android Tablet", type: .phone, ipAddress: "192.168.1.60", macAddress: "00:1F:2A:3B:4C:5D", status: .secure),
        Device(id: 7, name: "Unrecognized IoT Device", type: .other, ipAddress: "192.168.1.70", macAddress: "00:2A:3B:4C:5D:6E", status: .unsecure, message: "DEVICE UNSECURE"),
        Device(id: 8, name: "HomePod Mini", type: .speaker, ipAddress: "192.168.1.80", macAddress: "00:2B:3C:4D:5E:6F", status: .secure),
        Device(id: 9, name: "Samsung Galaxy S22", type: .phone, ipAddress: "192.168.1.90", macAddress: "00:2C:3D:4E:5F:7A", status: .secure),
        Device(id: 10, name: "Random Smart Device", type: .other, ipAddress: "192.168.1.100", macAddress: "00:2D:3E:4F:5A:7B", status: .unsecure, message: "DEVICE UNSECURE"),
    ]
}
