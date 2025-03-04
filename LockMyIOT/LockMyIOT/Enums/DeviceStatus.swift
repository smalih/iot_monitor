//
//  DeviceStatus.swift
//  LockMyIOT
//
//  Created by Simon Malih on 04/03/2025.
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
