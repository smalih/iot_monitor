//
//  DevicesView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 23/12/2024.
//

import SwiftUI

struct DevicesView: View {
    var body: some View {
        ZStack (alignment: .leading) {
            VStack(alignment: .trailing) {
                HStack {
                    Text("My Devices")
                        .bold().font(.title)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "bell.badge.fill")
                        .font(.title)
                        .padding()
                    
                }
                
                NavigationStack {
                    List {
                        DeviceRow(device: DeviceBody(deviceName: "iPhone 12 Pro", deviceType: "Phone", deviceIP: "192.168.1.1", deviceStatus: "Secure"))
                            .listRowInsets(EdgeInsets())
//                            .background(Color.indigo)

                        
                            
                       DeviceRow(device: DeviceBody(deviceName: "iPhone 12 Prrerro", deviceType: "Phone", deviceIP: "192.168.1.2", deviceStatus: "Secure"))
                            .listRowInsets(EdgeInsets())
                    }
                    .listStyle(PlainListStyle())
                    .border(.blue)
            
//                    .frame(maxWidth: .infinity)
                    
                }

    
            }
        }
    }
}

#Preview("Devices View") {
    DevicesView()
}
