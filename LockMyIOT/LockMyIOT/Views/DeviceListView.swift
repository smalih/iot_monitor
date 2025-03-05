//
//  DeviceListView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 23/12/2024.
//

import SwiftUI

struct DeviceListView: View {
    @StateObject var viewModel: DeviceListViewModel

    var body: some View {
        NavigationStack {
            // Check if devices are available
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("IP: \(viewModel.serverIp)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Port: \(viewModel.serverPort)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                if viewModel.devices.isEmpty {
                    EmptyDeviceListView()
                } else {
                    List(viewModel.devices) { device in
                        NavigationLink {
                            DeviceDetailView(device: device)
                        } label: {
                            DeviceListItemView(device: device)
                        }
                    }
                }
            }
            
        }
        .navigationTitle("Device List")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.startFetching()
        }
        .onDisappear {
            viewModel.stopFetching()
        }
    }
}

#Preview("Devices View") {
    let viewModel = DeviceListViewModel(
        devices: Device.mockDevices,
        serverIp: "192.168.1.30",
        serverPort: "8000",
        deviceManager: MockDeviceManager()
    )
    return NavigationStack {
        DeviceListView(viewModel: viewModel)
    }
}
