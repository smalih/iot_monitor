//
//  DeviceListViewModel.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 26/12/2024.
//

import Foundation

final class DeviceListViewModel: ObservableObject { 
    @Published var devices: [Device] = []
    private var timer: Timer?
    
    func startFetching(serverIp: String, serverPort: String) {
        stopFetching()
        
        Task {
            await fetchDevices(serverIp: serverIp, serverPort: serverPort)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            Task {
                await self?.fetchDevices(serverIp: serverIp, serverPort: serverPort)
            }
        }
    }
    
    func stopFetching() {
        timer?.invalidate()
        timer = nil
    }

    @MainActor
    func fetchDevices(serverIp: String, serverPort: String) async {
        
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
            print("Devices fetched")

        } catch {
            print("Failed to fetch device list: \(error)")
        }
    }
}
