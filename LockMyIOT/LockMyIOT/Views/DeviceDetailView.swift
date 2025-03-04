//
//  DeviceDetailView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 24/12/2024.
//

import SwiftUI

struct DeviceDetailView: View {
    let device: Device

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 20) {
                Text("IP Address: ").bold() + Text(device.ipAddress)
                Text("Mac Address: \(device.macAddress)")
                HStack(spacing: 0) {
                    Text("Status: ")
                    Text(device.status.rawValue)
                        .bold()
                        .foregroundColor(device.status.color)
                }

            }
            .padding()
            Spacer()
            Button("DISCONNECT") {

            }
            .buttonStyle(.borderedProminent)
            .background(Color.white)
            .tint(.red)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(device.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DeviceDetailView(device: .standard)
    }
}
