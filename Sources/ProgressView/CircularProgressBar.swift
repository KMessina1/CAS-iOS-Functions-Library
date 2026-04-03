/*--------------------------------------------------------------------------------------------------------------------------
    File: CircularProgressBar.swift
  Author: Kevin Messina
 Created: 1/19/25
Modified:
 
©2025 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

struct CPV: View {
    @State private var progress: Double = 0.2 // example progress value
    
    var body: some View {
        VStack {
            CircularProgressView(progress: $progress, size: 200, color: .orange, text: "Loading Records...")
            
            Slider(value: $progress, in: 0...1) // Slider to adjust progress for demonstration
                .padding()
        }
    }
}

struct CircularProgressView: View {
    @Binding var progress: Double
    let size: CGFloat
    let color: Color
    let text: String

    var body: some View {
        ZStack {
            blurredView(backgroundMaterial: .thickMaterial, opacity: 0.66).ignoresSafeArea()

            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.Tungsten)
                .strokeBorder(Color.white.opacity(0.33), lineWidth:2, antialiased: true)
                .frame(width: size, height: size)

            // Background for the progress bar
            Circle()
                .stroke(lineWidth: 12)
                .opacity(0.33)
                .foregroundStyle(color)
                .frame(width: size-35, height: size-35)

            // Foreground or the actual progress bar
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                .foregroundStyle(color.gradient)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
                .frame(width: size-35, height: size-35)
            
            Text(text)
                .frame(width: size-75, height: size-75)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .minimumScaleFactor(0.25)
        }
    }
}

#Preview {
    CPV()
}
