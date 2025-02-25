//
//  WelcomeView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 22/12/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var serverIp: String = ""
    @State private var serverPort: String = ""
    @State private var isNavigating = false
    var body: some View {
        NavigationStack {
            Form {
                TextField("Server IP", text: $serverIp)
                
                TextField("Port", text: $serverPort)
                
                //                NavigationLink(destination: DeviceListView(serverIp: serverIp, serverPort: serverPort)) {
                //                    Text("Enter")
                
                Button("Enter") {
                    isNavigating = true
                }
                
            }
            .navigationDestination(isPresented: $isNavigating) {
                DeviceListView(serverIp: serverIp, serverPort: serverPort)
//                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
