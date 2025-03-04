//
//  DeviceListItemView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 22/12/2024.
//

import SwiftUI

struct DeviceListItemView: View {
    let device: Device

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(systemName: device.type.icon)
                    .font(.title2)
                    .frame(width: 20, height: 20)
                    .padding()
                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                    .cornerRadius(50)

                VStack(alignment: .leading) {
                    Text(device.name)
                        .bold()
                        .font(.title3)
                    Text(device.ipAddress)
                        .bold()
                        .font(.caption)
                        .foregroundStyle(.gray)
                }

                Spacer()

                Text(device.status.rawValue)
                    .font(.title3)
                    .bold()
                    .foregroundColor(device.status.color)
                Image(systemName: "chevron.forward")
            }
            Divider()
        }
    }
}

#Preview {
    NavigationLink {
        DeviceDetailView(device: .standard)
    } label: {
        DeviceListItemView(device: .standard)
    }
    .padding()
}
