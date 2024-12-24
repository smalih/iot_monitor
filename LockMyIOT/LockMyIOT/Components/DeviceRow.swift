//
//  DeviceRow.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 22/12/2024.
//

import SwiftUI

struct DeviceRow: View {
    var device: DeviceBody
    var body: some View {
        
            
        NavigationLink(destination: DeviceView(device: device)) {
                HStack(spacing: 20) {
                    Image(systemName: "iphone")
                        .font(.title2)
                        .frame(width: 20, height: 20)
                        .padding()
                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                        .cornerRadius(50)
                    
                    
                    VStack(alignment: .leading) {
                        Text(device.deviceIP)
                            .bold()
                            .font(.caption)
                        
                        Text(device.deviceName)
                            .bold()
                            .font(.title)
                        
                    }
                    .border(.red)
                    
                    Spacer()
                        .frame(maxWidth: 20)
//                    VStack(alignment: .trailing, spacing: 100) {
                        Text(device.deviceStatus)
                            .font(.title)
                            .foregroundColor(Color("StatusGreen"))
//                            .padding()
                            .border(.red)
                            .frame(alignment: .leading)
//                    }
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct DeviceRow_Preiews: PreviewProvider {
    static var previews: some View {
        DeviceRow(device: mockDevice)
    }
}
