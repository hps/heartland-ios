//
//  DevicesView.swift
//  Heartland-iOS-SDK
//
//

import SwiftUI
import TemLibrary

@available(iOS 16.0, *)
public struct MobyDevicesView: View {
    
    @State private var showToastLoading = false
    @State var listDevices: [RuaDevice] = []
    
    @State private var device: RuaDevice? = nil
    
    @State private var mobyDevice: HpsMobyDevice?
    
    public init() {
    
    }
    
    public var body: some View {
        NavigationSplitView(columnVisibility: .constant(NavigationSplitViewVisibility.all)) {
            if(!listDevices.isEmpty){
                ScrollView {
                    ForEach(listDevices, id: \.self) { device in
                        VStack {
                            Divider()
                            NavigationLink(
                                destination: MobyDeviceDetailView(deviceSelected: device, mobyDevice: mobyDevice!),
                                label: {
                                    Text("\(device.deviceName)")
                                })
                            .navigationViewStyle(StackNavigationViewStyle())
                        }
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        
                        Spacer()
                    }
                }
                .padding(0)
            } else {
                VStack {
                    Text("No Devices Found!")
                        .foregroundColor(.primary)
                        .font(.title3)
                }
            }
        } detail: {
            if let device, let mobyDevice {
                MobyDeviceDetailView(deviceSelected: device, mobyDevice: mobyDevice)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .navigationSplitViewColumnWidth(ideal: 250)
        .navigationSplitViewColumnWidth(250)
        .navigationBarTitle("Moby Connection")
        .navigationBarHidden(false)
        .toolbarRole(.navigationStack)
        .toolbar(.hidden, for: .tabBar, .bottomBar)
        .navigationBarBackButtonHidden(false)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            launchDeviceSearching()
        }
    }
    
    func launchDeviceSearching(searchEnded: (() -> Void)? = nil) -> Void {
        showToastLoading = true
        
        let timeout = 120

        let config = HpsConnectionConfig()
        config.username = "703674685"
        config.password = "$Test1234"
        config.siteID = "372880"
        config.deviceID = "90915912"
        config.licenseID = "372711"
        config.developerID = "002914"
        config.versionNumber = "3409"
        
        config.timeout = timeout
        
        self.mobyDevice = HpsMobyDevice(config: config)
        
        self.mobyDevice?.searchDevice { devices in
            listDevices = devices
            showToastLoading = false
            if(searchEnded != nil){
                searchEnded!()
            }
        }
    }
}
