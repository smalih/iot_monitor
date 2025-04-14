//
//  DeviceListView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 23/12/2024.
//

import SwiftUI

struct DeviceListView: View {
    @AppStorage("isFIrstLaunch") private var isFirstLaunch = false
    @AppStorage("serverIp") private var storedServerIp: String = ""
    @AppStorage("serverPort") private var storedServerPort: String = ""
    
    @Environment(\.dismiss) var dismiss // Used to go back to the previous screen
    
    @StateObject var viewModel: DeviceListViewModel
    
    @State private var isNavigating: Bool = false;
    var body: some View {
        NavigationStack {
            // Check if devices are available
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("IP: \(viewModel.serverIp)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Port: \(viewModel.serverPort)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                if viewModel.devices.isEmpty {
                    EmptyDeviceListView()
                } else {
                    VStack{
                        List(viewModel.devices) { device in
                            NavigationLink {
                                DeviceDetailView(device: device)
                            } label: {
                                DeviceListItemView(device: device)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color(UIColor.systemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        
                        HStack {
                            Button(action: {
                                dismiss() // Go back to the previous screen
                            }) {
                                Text("Disconnect")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGroupedBackground))
                        .edgesIgnoringSafeArea(.all)
                        .navigationDestination(isPresented: $isNavigating) {
                            WelcomeView()
                                .navigationBarBackButtonHidden(true)
                        }
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                    
                }
                
            }
            .edgesIgnoringSafeArea(.bottom)
            
        }
        .navigationTitle("Device List")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.startFetching()
        }
        .onDisappear {
            viewModel.stopFetching()
        }
    }
}

#Preview("Devices View") {
    let viewModel = DeviceListViewModel(
        devices: Device.mockDevices,
        serverIp: "192.168.1.30",
        serverPort: "8000",
        deviceManager: MockDeviceManager()
    )
    return NavigationStack {
        DeviceListView(viewModel: viewModel)
    }
}
