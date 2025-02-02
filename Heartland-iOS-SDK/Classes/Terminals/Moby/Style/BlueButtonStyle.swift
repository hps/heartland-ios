//
//  BlueButtonStyle.swift
//  Heartland-iOS-SDK
//
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
struct BlueButtonStyle: ButtonStyle {
    let width: CGFloat
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
           MyButton(width: width, configuration: configuration)
       }

       struct MyButton: View {
           let width: CGFloat
           let configuration: ButtonStyle.Configuration
           @Environment(\.isEnabled) private var isEnabled: Bool
           var body: some View {
               configuration.label
                   .padding(.horizontal)
                   .padding(.vertical, 6)
                   .frame(maxWidth: width)
                   .background(!isEnabled ? Color.background.opacity(0.5) : Color.background)
                   .foregroundColor(!isEnabled ? .white : Color.foreground)
                   .opacity(configuration.isPressed ? 0.5 : 1)
                   .clipShape(RoundedRectangle(cornerRadius: 5))
           }
       }
}
