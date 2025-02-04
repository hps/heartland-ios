//
//  DevicesView.swift
//  Heartland-iOS-SDK
//
//

import SwiftUI
import GlobalMobileSDK

@available(iOS 16.0, *)
public struct MobyDevicesView: View {
    
    @State private var showToastLoading = false
    @State var listDevices: [RuaDevice] = []
    
    @State private var device: RuaDevice? = nil
    
    @State private var mobyDevice: HpsMobyDevice?
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var siteID: String = ""
    @State private var developerID: String = ""
    @State private var versionNumber: String = ""
    @State private var licenseID: String = ""
    @State private var deviceID: String = ""
    
    @State private var showViewForCredentials: Bool = true
    
    public init() {
    
    }
    
    public var body: some View {
        if showViewForCredentials {
            credentialsView
        } else {
            NavigationSplitView(columnVisibility: .constant(NavigationSplitViewVisibility.all)) {
                if(!listDevices.isEmpty){
                    ScrollView {
                        ForEach(listDevices, id: \.self) { device in
                            VStack {
                                Divider()
                                NavigationLink(
                                    destination: MobyDeviceDetailView(deviceSelected: device),
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
                    MobyDeviceDetailView(deviceSelected: device)
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
    }
    
    var credentialsView: some View {
           VStack{
               Text("Credentials").font(.headline.bold()).underline().padding()
               HStack(spacing: 2) {
                   
                   Spacer()
                   
                   VStack {
                       TextField(
                           "Username",
                           text: $username
                       )
                       .autocapitalization(.none)
                       .disableAutocorrection(false)
                       .padding(.top, 20)
                       
                       Divider()
                       
                       SecureField(
                           "Password",
                           text: $password
                       )
                       .padding(.top, 20)
                       
                       Divider()
                       
                       TextField(
                           "SiteID",
                           text: $siteID
                       )
                       .autocapitalization(.none)
                       .disableAutocorrection(false)
                       .padding(.top, 20)
                       
                       Divider()
                       
                       TextField(
                           "LicenseID",
                           text: $licenseID
                       )
                       .autocapitalization(.none)
                       .disableAutocorrection(false)
                       .padding(.top, 20)
                       
                       Divider()
                       
                       TextField(
                           "DeveloperID",
                           text: $developerID
                       )
                       .autocapitalization(.none)
                       .disableAutocorrection(false)
                       .padding(.top, 20)
                       
                       Divider()
                       
                       TextField(
                           "VersionNumber",
                           text: $versionNumber
                       )
                       .autocapitalization(.none)
                       .disableAutocorrection(false)
                       .padding(.top, 20)
                       
                       Divider()
                       
                       TextField(
                           "DeviceID",
                           text: $deviceID
                       )
                       .autocapitalization(.none)
                       .disableAutocorrection(false)
                       .padding(.top, 20)
                       
                   }
                   
               }
               
               HStack {
                   Button(action: {
                       launchDeviceSearching()
                       self.showViewForCredentials = false
                       
                   }){
                       Text("START")
                           .padding(20)
                           .foregroundColor(.red)
                   }
                   .buttonStyle(BlueButtonStyle(width: .infinity))
                   .disabled(showToastLoading)
                   
                   Spacer()
                   
                   Button(action: {
                       self.showViewForCredentials = false
                   }){
                       Text("CANCEL")
                           .foregroundStyle(.red)
                           .padding(20)
                   }
                   .buttonStyle(BlueButtonStyle(width: .infinity))
                   .disabled(!showToastLoading)
                   
               }
               
           }.padding()
               .background(
                   RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.systemBackground))
                       .shadow(color: .gray, radius: 8, x: 2, y: 2)
               )
       }
    
    func launchDeviceSearching(searchEnded: (() -> Void)? = nil) -> Void {
        showToastLoading = true
        
        let timeout = 120

        let config = HpsConnectionConfig()
        config.username = self.username
        config.password = self.password
        config.siteID = self.siteID
        config.deviceID = self.deviceID
        config.licenseID = self.licenseID
        
        config.developerID = self.developerID
        config.versionNumber = self.versionNumber
        
        config.timeout = timeout
    
        RUUAHelper.sharedInstance.initializeWith(config: config) { result1, result2 in
            print(result1)
            print(result2)
        } releaseCompletionBlock: { isConnected in
            print("releaseCompletionBlock")
            showToastLoading = RUUAHelper.sharedInstance.showLoadingScreen
        }

        RUUAHelper.sharedInstance.startSearchingDevices { devices in
            listDevices = devices
            showToastLoading = RUUAHelper.sharedInstance.showLoadingScreen
            if(searchEnded != nil){
                searchEnded!()
            }
        }
    }
}
