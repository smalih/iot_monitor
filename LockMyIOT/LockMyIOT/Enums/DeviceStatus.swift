//
//  DeviceStatus.swift
//  LockMyIOT
//
//

import SwiftUI

enum DeviceStatus: String, Decodable {
    case secure = "SECURE"
    case unsecure = "UNSECURE"

    var color: Color {
        switch self {
        case .secure:
                .statusGreen
        case .unsecure:
                .red
        }
    }
}
