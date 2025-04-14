//
//  WelcomeView.swift
//  LockMyIOT
//
//  Created by Solomon Malih on 22/12/2024.
//

import SwiftUI

struct WelcomeView: View {
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("serverIp") private var serverIp: String = ""
    @AppStorage("serverPort") private var serverPort: String = ""
//    @State private var showDeviceList = false redundant??
    private let logoHeight: CGFloat = 200
    
    var canNotConnectToServer: Bool {
        serverIp.isEmpty || serverPort.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                // Logo at the top
                Image("Logo") // Replace "your_logo_name" with the actual name of your logo image in your asset catalog
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoHeight, height: logoHeight) // Adjust the size to fit your needs
//                    .padding(.top, 100)  Add top padding if you want more space between logo and the fields
                Text("Add IP Address and Port Number to connect to the server")
                    .font(.title3) // Increased font size
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                    .padding([.bottom, .horizontal])
                Spacer()
                VStack(spacing: 30) {
                    textfield(title: "IP Address", placeholder: "Enter IP address", text: $serverIp, keyboardType: .decimalPad)
                    textfield(title: "Port Number", placeholder: "Enter Port", text: $serverPort, keyboardType: .numberPad)
                    Spacer()
                    
                    // NavigationLink wrapped inside a Button
                    NavigationLink(
                        destination: DeviceListView(
                            viewModel: DeviceListViewModel(
                                serverIp: serverIp,
                                serverPort: serverPort
                            )
                        )
                    ) {
                        Text("Connect")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canNotConnectToServer ? Color.gray : Color.blue) // Disable button if fields are empty
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 30) // Add bottom padding for spacing
                    }
                    .disabled(canNotConnectToServer) // Disable navigation link if fields are empty
                }
                .padding()
            }
            .background(Color(UIColor.systemBackground)) // Set the background color of the whole view
//            .edgesIgnoringSafeArea(.all)  Ensure background color stretches fully
            .navigationBarBackButtonHidden(true) // Hide the back button when navigating
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer() // Pushes the button to the right
                    Button("Done") {
                        // Resign the first responder (dismiss the keyboard)
                        isFirstLaunch = false
                        print("Done button")
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
    func textfield(title: String, placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.body)
                .foregroundColor(.gray)
            
            TextField(placeholder, text: text)
                .keyboardType(keyboardType)
                .padding(10) // Increase the padding to add more space inside the TextField
//                .background(Color.white)
                .cornerRadius(12) // Adjust the corner radius to match your design
                .overlay(
                    RoundedRectangle(cornerRadius: 12) // Match the corner radius
                        .stroke(Color.gray, lineWidth: 2) // Set the color and thickness of the border
                )
        }
    }
}

#Preview {
    WelcomeView()
}
