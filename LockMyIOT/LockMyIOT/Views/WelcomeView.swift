//
//  WelcomeView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 22/12/2024.
//

import SwiftUI

struct WelcomeView: View {

    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @AppStorage("serverIp") private var serverIp: String = ""
    @AppStorage("serverPort") private var serverPort: String = ""
    @State private var isNavigating = false
    var body: some View {
        NavigationStack {
            Form {
                TextField("Server IP", text: $serverIp)
                    .keyboardType(.decimalPad)

                TextField("Port", text: $serverPort)
                    .keyboardType(.numberPad)

                //                NavigationLink(destination: DeviceListView(serverIp: serverIp, serverPort: serverPort)) {
                //                    Text("Enter")
                Button("Enter") {
                    isNavigating = true
                    isFirstLaunch = false
                }
//                .disabled(serverIp.isEmpty || serverPort.isEmpty)
            }
            .navigationDestination(isPresented: $isNavigating) {
                DeviceListView(viewModel: DeviceListViewModel(serverIp: serverIp, serverPort: serverPort))
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
