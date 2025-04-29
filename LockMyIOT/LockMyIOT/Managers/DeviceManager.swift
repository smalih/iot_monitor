//
//  DeviceManager.swift
//  LockMyIOT
//
//

import Foundation

protocol DeviceManagerProtocol {
    func fetchDevices(serverIp: String, serverPort: String) async -> [Device]?
    func updateDevice(serverIp: String, serverPort: String, device: Device) async -> Bool
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
    
    func updateDevice(serverIp: String, serverPort: String, device: Device) async -> Bool {
        guard let url = URL(string: "http://\(serverIp):\(serverPort)/update") else {
            print("Invalid URL")
            return false
        }
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PUT"  // You might want to use "PUT" depending on your backend
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encodedDevice = try JSONEncoder().encode(device)
            urlRequest.httpBody = encodedDevice
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Device updated successfully")
                    return true
                } else {
                    print("Failed with HTTP status: \(httpResponse.statusCode)")
                    return false
                }
            } else {
                print("Invalid response from server")
                return false
            }
        } catch {
            print("Failed to update device: \(error)")
            return false
        }
    }
}

struct MockDeviceManager: DeviceManagerProtocol {
    var fetchDevicesCallback: () -> [Device]? = {
        Device.mockDevices
    }
    
    var updateDeviceCallback: () -> Bool = {true}
    
    func fetchDevices(serverIp: String, serverPort: String) async -> [Device]? {
        fetchDevicesCallback()
    }
    
    func updateDevice(serverIp: String, serverPort: String, device: Device) async -> Bool {
        updateDeviceCallback()
    }
}
