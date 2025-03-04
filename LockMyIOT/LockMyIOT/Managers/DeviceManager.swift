//
//  DeviceManager.swift
//  LockMyIOT
//
//  Created by Simon Malih on 04/03/2025.
//

import Foundation

protocol DeviceManagerProtocol {
    func fetchDevices(serverIp: String, serverPort: String) async -> [Device]?
}

struct DeviceManager: DeviceManagerProtocol {
    /// Fetch device list from back end
    /// - Parameters:
    ///   - serverIp: Server IP Adress
    ///   - serverPort: Server Port
    /// - Returns: List of devices
    func fetchDevices(serverIp: String, serverPort: String) async -> [Device]? {
        guard let url =  URL(string: "http://\(serverIp):\(serverPort)/devices") else {
            print("Invalid URL")
            return nil
        }

        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET" // Explicitly set HTTP method

            // Optional: Add headers if required by the server
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Error: \(httpResponse.statusCode)")
                return nil
            }

            let deviceList = try JSONDecoder().decode([Device].self, from: data)
            print("Device list fetched!")
            return deviceList
        } catch {
            print("Failed to fetch device list with error: \(error)")
            return nil
        }
    }
}

struct MockDeviceManager: DeviceManagerProtocol {
    var fetchDevicesCallback: () -> [Device]? = {
        Device.mockDevices
    }

    func fetchDevices(serverIp: String, serverPort: String) async -> [Device]? {
        fetchDevicesCallback()
    }
}
