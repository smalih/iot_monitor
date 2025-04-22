//
//  ContentView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 22/12/2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @AppStorage("serverIp") private var serverIp = ""
    @AppStorage("serverPort") private var serverPort = ""

    @State private var checkWelcomeScreen: Bool = true
    var body: some View {
        VStack {
            if checkWelcomeScreen {
                WelcomeView()
            } else {
                DeviceListView(viewModel: DeviceListViewModel(serverIp: serverIp, serverPort: serverPort))
            }
        }
        .onAppear {
            checkWelcomeScreen = isFirstLaunch
        }
    }
}

#Preview {
    ContentView()
}
