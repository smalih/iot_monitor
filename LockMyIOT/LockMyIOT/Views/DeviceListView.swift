//
//  DeviceListView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 23/12/2024.
//

import SwiftUI

struct DeviceListView: View {
    let serverIp: String
    let serverPort: String
    @StateObject var viewModel = DeviceListViewModel()
    
    var body: some View {
        ZStack (alignment: .leading) {
            NavigationStack {
                VStack(alignment: .trailing) {
                    HStack {
                        
                        Text("My Devices")
                            .bold().font(.title)
                        Spacer()
                        Image(systemName: "bell.badge.fill")
                            .font(.title)
                    }
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(viewModel.devices) { device in
                            NavigationLink {
                                DeviceDetailView(device: device)
                            } label: {
                                DeviceListItemView(device: device)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                
//                    HStack {
//                        Text("Sticky footer")
//                            .padding()
//                            .background(.green)
//                            .foregroundStyle(.blue)
//                            .cornerRadius(10)
//                            .frame(maxWidth: .infinity)
//                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchDevices(serverIp: serverIp, serverPort: serverPort)
            }
        }
    }
}

#Preview("Devices View") {
    DeviceListView(serverIp: "192.168.1.30", serverPort: "8000")
}
