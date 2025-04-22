//
//  DeviceDetailView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 24/12/2024.
//

import SwiftUI

struct DeviceDetailView: View {
    @State var editMode = false
    @State var nameInEditMode = false
    @State var deviceTypeInEditMode = false
    @State var name = "Test Phone"
    let device: Device
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Device Type Icon (Top Center)
            ZStack {
                // Center the main item
                Image(systemName: device.type.icon)
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding(.top, 40)
                
                if editMode {
                    // Overlay the second item just beside it
                    HStack(spacing: 50) {
                        Image(systemName: device.type.icon)
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .padding(.top, 40)
                            .opacity(0) // Invisible, but takes up same space
                        Menu {
                            ForEach(DeviceType.allCases, id: \.self) {deviceT in
                                Button {}
                                label: {
                                    Label(deviceT.rawValue, systemImage: deviceT.icon)
                                }
                            }
                        } label: {
                            Image(systemName: "arrowtriangle.down.square.fill")
                                .font(.system(size: 25))
                                .foregroundColor(Color(UIColor.lightGray))
                                .padding(.top, 40)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                if nameInEditMode {
                    TextField("Name", text: $name)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300) // Optional width control
                        .textFieldStyle(PlainTextFieldStyle())
                } else {
                    Text(name)
                        .font(.largeTitle)
                        .bold()
                }
                
                if editMode {
                    Button(action: {
                        self.nameInEditMode.toggle()
                    }) {
                        Image(systemName: nameInEditMode ? "checkmark.circle.fill" : "pencil")
                            .font(.system(size: 30, weight: .bold))
                        
                    }
                }
            }
            // Device Details (Left-aligned)
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("IP Address:")
                        .font(.headline)
                    Spacer()
                    Text(device.ipAddress)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("MAC Address:")
                        .font(.headline)
                    Spacer()
                    Text(device.macAddress)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Status:")
                        .font(.headline)
                    Spacer()
                    Text(device.status.rawValue)
                        .foregroundColor(device.status.color)
                        .font(.body)
                }
                if device.status == .unsecure {
                    Text(device.message)
                        .foregroundColor(device.status.color)
                        .font(.body)
                }
            }
            .padding(.horizontal)
            .toolbar {
                if editMode {
                    Button("Save") {
                        print("need to send details to server")
                        editMode = false
                    }
                }
                else {
                    Button("Edit") {
                        editMode = true
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        DeviceDetailView(device: .standard)
    }
}
