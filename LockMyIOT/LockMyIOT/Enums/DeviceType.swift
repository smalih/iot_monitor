//
//  DeviceType.swift
//  LockMyIOT
//
//  Created by Simon Malih on 04/03/2025.
//

import Foundation

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
