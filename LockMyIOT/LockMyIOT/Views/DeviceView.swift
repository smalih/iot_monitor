//
//  DeviceView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 24/12/2024.
//

import SwiftUI

struct DeviceView: View {
    var device: DeviceBody
    var body: some View {
        VStack(alignment: .leading) {
            Text(device.deviceName)
                .font(.title)
                .bold()
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .border(.red)
        Spacer()
        VStack(alignment: .leading) {
            Text("IP Address: " + device.deviceIP)
        }
    }
}

#Preview {
    DeviceView(device: mockDevice)
}
