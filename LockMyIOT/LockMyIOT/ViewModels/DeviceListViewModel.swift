//
//  DeviceListViewModel.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 26/12/2024.
//

import Foundation

final class DeviceListViewModel: ObservableObject { 
    @Published var devices: [Device] = []
    
//    @MainActor
//    func fetchDevices() async {
////        devices = DeviceFactory.devices
//
//        guard let url = URL(string: "https://192.168.1.30:8000/devices") else {
//            print("Invalid URL")
//            return
//        }
//        
//        do {
//            let urlRequest = URLRequest(url: url)
//            
//            let (data, _) = try await URLSession.shared.data(for: urlRequest)
//            
//
//            
//            
//            let deviceList = try JSONDecoder().decode([Device].self, from: data)
//            devices = deviceList
//        } catch {
//            print("Failed to fetch device list: \(error.localizedDescription)")
//        }
//    }
    @MainActor
    func fetchDevices(serverIp: String, serverPort: String) async {
        
        
//        let jsonString = """
//        [
//            {
//                "id": 1,
//                "mac_addr": "01:23:45:67:89:ab",
//                "ip_addr": "192.168.0.1",
//                "name": "Test Phone 2",
//                "type": "PHONE",
//                "status": "SECURE"
//            }
//        ]
//        """
//
//        // Convert JSON string to Data
//        if let jsonData = jsonString.data(using: .utf8) {
//            do {
//                // Decode JSON into an array of Device objects
//                let devices = try JSONDecoder().decode([Device].self, from: jsonData)
//                
//                // Access the first device
//                if let firstDevice = devices.first {
//                    print("Device Name: \(firstDevice.name)")
////                    print("MAC Address: \(firstDevice.mac_addr)")
//                    print("Status: \(firstDevice.status)")
//                }
//                
//                self.devices = devices
//            } catch {
//                print("Error decoding JSON: \(error)")
//            }
//        }

        
        
        
        // Ensure the URL is properly formatted
        guard let url = URL(string: "http://\(serverIp):\(serverPort)/devices") else {
            print("Invalid URL")
            return
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
                return
            }

            let deviceList = try JSONDecoder().decode([Device].self, from: data)

            devices = deviceList // Assuming `devices` is a @State or @Published variable

        } catch {
            print("Failed to fetch device list: \(error)")
        }
    }
}
