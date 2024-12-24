//
//  DeviceManager.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 24/12/2024.
//

import Foundation


struct DeviceBody: Decodable {
    var deviceName: String
    var deviceType: String
    var deviceIP: String
    var deviceStatus: String
}
