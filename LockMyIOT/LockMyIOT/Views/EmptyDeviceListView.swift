//
//  EmptyDeviceListView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 22/12/2024.
//

import SwiftUI

struct EmptyDeviceListView: View {
    @Environment(\.dismiss) var dismiss // Used to go back to the previous screen
    @AppStorage("isFirstLaunch") private var isFirstLaunch = false
    @AppStorage("serverIp") private var storedServerIp: String = ""
    @AppStorage("serverPort") private var storedServerPort: String = ""
    
    @State private var isNavigating: Bool = false;
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No devices detected")
                .font(.title2)
                .foregroundColor(.gray)
                .padding()
            
            Text("Ensure you are connected to the server and that your devices are powered on.")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.bottom, 30)
            
            Button(action: {
                dismiss() // Go back to the previous screen
                isNavigating = true
                storedServerIp = ""
                storedServerPort = ""
                isFirstLaunch = false
            }) {
                Text("Disconnect")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
        .navigationDestination(isPresented: $isNavigating) {
            WelcomeView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    EmptyDeviceListView()
}
