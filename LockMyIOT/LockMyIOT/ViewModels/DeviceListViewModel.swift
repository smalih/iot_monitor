//
//  DeviceListViewModel.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 26/12/2024.
//

import Foundation

final class DeviceListViewModel: ObservableObject {
    @Published var devices: [Device]
    let serverIp: String
    let serverPort: String
    private var timer: Timer?
    private let timeInterval: TimeInterval
    private let deviceManager: DeviceManagerProtocol

    init(
        devices: [Device] = [],
        serverIp: String,
        serverPort: String,
        deviceManager: DeviceManagerProtocol = DeviceManager(),
        timer: Timer? = nil,
        timeInterval: TimeInterval = 10
    ) {
        self.devices = devices
        self.serverIp = serverIp
        self.serverPort = serverPort
        self.timer = timer
        self.timeInterval = timeInterval
        self.deviceManager = deviceManager
    }

    deinit {
        stopFetching()
    }

    func startFetching() {
        stopFetching()

        Task { [weak self] in
            guard let self else { return }
            if let updatedDevices = await deviceManager.fetchDevices(serverIp: serverIp, serverPort: serverPort) {
                devices = updatedDevices
            }
        }

        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            Task { [weak self] in
                guard let self else { return }
                if let updatedDevices = await deviceManager.fetchDevices(serverIp: serverIp, serverPort: serverPort) {
                    devices = updatedDevices
                }
            }
        }
    }

    func stopFetching() {
        timer?.invalidate()
        timer = nil
    }
}
