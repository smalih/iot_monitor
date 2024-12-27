//
//  DeviceListViewModel.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 26/12/2024.
//

import Foundation

final class DeviceListViewModel: ObservableObject { 
    @Published var devices: [Device] = []
    
    func fetchDevices() async {
        self.devices = DeviceFactory.devices
    }
}
