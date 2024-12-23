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
                        DeviceRow(deviceType: "Phone", deviceName: "Test 1", deviceStatus: "Secure", deviceIP: "192.168.1")
                            .listRowInsets(EdgeInsets())
//                            .background(Color.indigo)

                        
                            
                        DeviceRow(deviceType: "Phone", deviceName: "Test 1", deviceStatus: "Secure", deviceIP: "192.168.1")
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
