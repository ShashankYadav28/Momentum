//
//  RecoveryScreen.swift
//  Momentum
//
//  Created by Shashank Yadav on 09/08/26.
//

import SwiftUI

struct RecoveryScreen:View {
    let onRetry: () -> Void
    var body: some View {
        
        VStack(spacing: 18){
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 90))
            
            VStack {
                Text("App Failed to Start")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("We couldn’t prepare your local data. Please try again.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            
            Button("Try Again") {
                onRetry()
            }
            .buttonStyle(.glassProminent)
                
           
        }
        .padding()
    }
}
#Preview {
    RecoveryScreen(onRetry: { print("retry")})
}

