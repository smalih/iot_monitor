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
    
    @AppStorage("isFIrstLaunch") private var isFirstLaunch = false
    @AppStorage("serverIp") private var storedServerIp: String = ""
    @AppStorage("serverPort") private var storedServerPort: String = ""
    
    @StateObject var viewModel = DeviceListViewModel()
    
    @State private var isNavigating = false
    
    var body: some View {
        ZStack (alignment: .leading) {
            
            NavigationStack {
                VStack(alignment: .trailing) {
                    HStack {
                        
                        Text("My Devices - \(serverIp)")
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
                    
                    HStack {
                        Button("Exit") {
                            isNavigating = true
                            storedServerIp = ""
                            storedServerPort = ""
                            isFirstLaunch = false
                            
                        }
                        .padding()
                        .background(.red)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    }
                    .navigationDestination(isPresented: $isNavigating) {
                        WelcomeView()
                            .navigationBarBackButtonHidden(true)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            viewModel.startFetching(serverIp: serverIp, serverPort: serverPort)
        }
        .onDisappear {
            viewModel.stopFetching()
        }
    }
}

#Preview("Devices View") {
    DeviceListView(serverIp: "192.168.1.30", serverPort: "8000")
}
