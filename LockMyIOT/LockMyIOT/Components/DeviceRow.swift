//
//  DeviceRow.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 22/12/2024.
//

import SwiftUI

struct DeviceRow: View {
    var deviceType: String
    var deviceName: String
    var deviceStatus: String
    var deviceIP: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "iphone")
                .font(.title2)
                .frame(width: 20, height: 20)
                .padding()
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                .cornerRadius(50)
            
            
            VStack(alignment: .leading) {
                Text(deviceIP)
                    .bold()
                    .font(.caption)
                
                Text(deviceName)
                    .bold()
                    .font(.title)
                
            }
            
            Spacer()
            VStack(alignment: .trailing, spacing: 20) {
                Text(deviceStatus)
                //                    .bold()
                    .font(.title)
                    .foregroundColor(Color("StatusGreen"))
            }
            Image(systemName: "arrow.right")
                .font(.title)
                .frame(width: 20, height: 20)
                .padding()
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct DeviceRow_Preiews: PreviewProvider {
    static var previews: some View {
        DeviceRow(deviceType: "Phone", deviceName: "iPhone 12 Pro", deviceStatus: "Secure", deviceIP: "192.168.1.0")
    }
}
