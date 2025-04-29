//
//  DeviceType.swift
//  LockMyIOT
//
//

import Foundation

enum DeviceType: String, Decodable, CaseIterable {
    case phone = "PHONE"
    case speaker = "SPEAKER"
    case other = "OTHER"

    var icon: String {
        switch self {
        case .phone:
            return "iphone"
        case .speaker:
            return "homepod.mini.badge.plus.fill"
        case .other:
            return "globe"
        }
    }
}
