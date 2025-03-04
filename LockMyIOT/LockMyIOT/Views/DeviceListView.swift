//
//  DeviceListView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 23/12/2024.
//

import SwiftUI

struct DeviceListView: View {
    @StateObject var viewModel: DeviceListViewModel
    @AppStorage("isFIrstLaunch") private var isFirstLaunch = false
    @AppStorage("serverIp") private var storedServerIp: String = ""
    @AppStorage("serverPort") private var storedServerPort: String = ""

    @State private var isNavigating = false

    var body: some View {
        NavigationStack {
            List(viewModel.devices) { device in
                NavigationLink {
                    DeviceDetailView(device: device)
                } label: {
                    DeviceListItemView(device: device)
                }
            }
        }
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
    return DeviceListView(viewModel: viewModel)
}
