//
//  DeviceDetailView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 24/12/2024.
//

import SwiftUI

struct DeviceDetailView: View {
    @State var device: Device
    
    @State var editMode = false
    @State var nameInEditMode = false
    @State var deviceTypeInEditMode = false
    @State var name: String
    
    @AppStorage("serverIp") var serverIp: String = ""
    @AppStorage("serverPort") var serverPort: String = ""
    private let deviceManager: DeviceManagerProtocol
    
    init(device: Device) {
        self.device = device
        _name = State(initialValue: device.name)
        deviceManager = DeviceManager()
    }
    
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
                                Button (action: {
                                    device.updateType(to: deviceT)
                                }) {
                                    
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
            
            
            // Device Name (Center)
            HStack {
                //                Text(device.name)
                //                    .font(.largeTitle)
                //                    .bold()
                //                    .padding(.top, 10)
                
                if nameInEditMode {
                    TextField("Name", text: $name)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300) // Optional width control
                        .textFieldStyle(PlainTextFieldStyle())
                } else {
                    Text(device.name)
                        .font(.largeTitle)
                        .bold()
                }
                
                if editMode {
                    Button(action: {
                        if self.nameInEditMode {
                            device.updateName(to: self.name)
                        }
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
                
                
                
                //                        Button(action: {
                //                            self.nameInEditMode.toggle()
                //                        }) {
                //                            Text(nameInEditMode ? "Done" : "Edit").font(.system(size: 20)).fontWeight(.light)
                //                                .foregroundColor(Color.blue)
                //                        }
                
                
                
                
            }
            .padding(.horizontal)
            .toolbar {
                if editMode {
                    Button("Save") {
                        Task {
                            await deviceManager.updateDevice(serverIp: serverIp, serverPort: serverPort, device: device)
                            editMode = false
                        }
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
