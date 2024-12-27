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
                Text("Latest Connection: ").bold() + Text("www.google.com")
                Text("Most Common Connection ").bold() + Text("www.apple.com")
            }
            .padding()
            Spacer()
                Button("DISCONNECT") { }
                    .buttonStyle(.borderedProminent)
                    .background(Color.white)
                    .tint(.red)
                    .frame(maxWidth: .infinity)
        }
        .navigationTitle(device.name)
    }
}

#Preview {
    DeviceDetailView(device: .standard)
}
