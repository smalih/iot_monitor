//
//  WelcomeView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 22/12/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var serverURL: String = ""
    @State private var serverPort: String = ""
    
    var body: some View {
        Form {
            TextField("Server URL", text: $serverURL)

            TextField("Port", text: $serverPort)
        }
    }
}

#Preview {
    WelcomeView()
}
