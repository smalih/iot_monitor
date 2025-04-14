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
        VStack(alignment: .center, spacing: 20) {
            // Device Type Icon (Top Center)
            Image(systemName: device.type.icon)
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding(.top, 40)
            
            // Device Name (Center)
            Text(device.name)
                .font(.largeTitle)
                .bold()
                .padding(.top, 10)
            
            // Device Details (Left-aligned)
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("IP Address:")
                        .font(.headline)
                    Spacer()
                    Text(device.ipAddress)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("MAC Address:")
                        .font(.headline)
                    Spacer()
                    Text(device.macAddress)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Status:")
                        .font(.headline)
                    Spacer()
                    Text(device.status.rawValue)
                        .foregroundColor(device.status.color)
                        .font(.body)
                }
                if device.status == .unsecure {
                    Text(device.message)
                        .foregroundColor(device.status.color)
                        .font(.body)
                }
                
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        DeviceDetailView(device: .standard)
    }
}
