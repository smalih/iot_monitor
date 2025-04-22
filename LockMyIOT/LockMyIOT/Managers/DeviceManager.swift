//
//  DeviceManager.swift
//  LockMyIOT
//
//  Created by Simon Malih on 04/03/2025.
//

import Foundation

protocol DeviceManagerProtocol {
    /// Fetches a list of devices from a backend server using the provided IP address and port number.
    ///
    /// This asynchronous method constructs a URL from the input parameters, sends an HTTP GET request,
    /// and attempts to decode the JSON response into an array of `Device` objects. If the request fails
    /// due to a networking error, invalid response, or decoding failure, the method returns `nil`.
    ///
    /// - Parameters:
    ///   - serverIp: The IP address of the backend server (e.g., `"192.168.1.10"`).
    ///   - serverPort: The port number on which the backend server is listening (e.g., `"8080"`).
    ///
    /// - Returns: An optional array of `Device` objects if the request and decoding are successful; otherwise, `nil`.
    ///
    /// - Note: This function logs errors and HTTP status codes to the console for debugging purposes.
    func fetchDevices(serverIp: String, serverPort: String) async -> [Device]?
}

/// Handles device-related operations such as fetching a list of devices from a specified backend server.
struct DeviceManager: DeviceManagerProtocol {
    
    /// Fetches a list of devices from a backend server using the provided IP address and port number.
    ///
    /// This asynchronous method constructs a URL from the input parameters, sends an HTTP GET request,
    /// and attempts to decode the JSON response into an array of `Device` objects. If the request fails
    /// due to a networking error, invalid response, or decoding failure, the method returns `nil`.
    ///
    /// - Parameters:
    ///   - serverIp: The IP address of the backend server (e.g., `"192.168.1.10"`).
    ///   - serverPort: The port number on which the backend server is listening (e.g., `"8080"`).
    ///
    /// - Returns: An optional array of `Device` objects if the request and decoding are successful; otherwise, `nil`.
    ///
    /// - Note: This function logs errors and HTTP status codes to the console for debugging purposes.
    func fetchDevices(serverIp: String, serverPort: String) async -> [Device]? {
        guard let url =  URL(string: "http://\(serverIp):\(serverPort)/devices") else {
            print("Invalid URL")
            return nil
        }
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            // Accept JSON responses from the server
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // Validate the HTTP response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Error: \(httpResponse.statusCode)")
                return nil
            }
            
            // Attempt to decode the response into a list of devices
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
