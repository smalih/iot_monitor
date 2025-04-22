//
//  DeviceListViewModel.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 26/12/2024.
//

import Foundation

/// Periodically fetches a list of devices from a backend server
final class DeviceListViewModel: ObservableObject {
    @Published var devices: [Device]
    let serverIp: String
    let serverPort: String
    private var timer: Timer?
    private let timeInterval: TimeInterval
    private let deviceManager: DeviceManagerProtocol

    /// - Parameters:
    ///   - devices: An initial list of devices to display. Defaults to an empty array.
    ///   - serverIp: The IP address of the backend server.
    ///   - serverPort: The port on which the backend server listens.
    ///   - deviceManager: An object conforming to `DeviceManagerProtocol` used for fetching devices. Defaults to a `DeviceManager` instance.
    ///   - timer: An optional timer instance (used for testing). Defaults to `nil`.
    ///   - timeInterval: The time interval, in seconds, for periodic refreshes. Defaults to `10` seconds.
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

    /// Starts fetching the device list from the backend at regular intervals.
    ///
    /// The method performs an initial fetch immediately, followed by scheduled fetches using a `Timer`.
    /// Fetching is performed asynchronously to avoid blocking the main thread.
    func startFetching() {
        stopFetching()

        // Perform the first fetch immediately
        Task { [weak self] in
            guard let self else { return }
            if let updatedDevices = await deviceManager.fetchDevices(serverIp: serverIp, serverPort: serverPort) {
                devices = updatedDevices
            }
        }

        // Schedule periodic fetches
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            Task { [weak self] in
                guard let self else { return }
                if let updatedDevices = await deviceManager.fetchDevices(serverIp: serverIp, serverPort: serverPort) {
                    devices = updatedDevices
                }
            }
        }
    }

    /// Stops periodic fetching of the device list and invalidates the timer.
    func stopFetching() {
        timer?.invalidate()
        timer = nil
    }
}
