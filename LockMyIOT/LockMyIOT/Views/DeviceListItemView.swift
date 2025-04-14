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
        HStack(spacing: 20) {
            Image(systemName: device.type.icon)
                .font(.title2)
                .frame(width: 20, height: 20)
                .padding()
                .background(Circle().fill(Color.blue.opacity(0.1)))
                .cornerRadius(50)
            VStack(alignment: .leading) {
                Text(device.name)
                    .font(.headline)
                Text(device.ipAddress)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(device.status.rawValue)
                .foregroundColor(device.status.color)
                .font(.subheadline)
                .padding(6)
                .background(device.status.color.opacity(0.2))
                .cornerRadius(8)
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
