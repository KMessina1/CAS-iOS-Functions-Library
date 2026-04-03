//--------------------------------------------------------------------------------------------------------------------------
//     File: Compass.swift
//   Author: Kevin Messina
//  Created: 2/3/26
// Modified:
// 
// ©2026 Creative App Solutions, LLC. - All Rights Reserved.
//--------------------------------------------------------------------------------------------------------------------------
// NOTES:
//--------------------------------------------------------------------------------------------------------------------------

import SwiftUI

public struct CompassView: View {
    let CT = CurrentTheme().getThemeFromUserStds()

    @Binding var currentPosition: Double
    var showReadout: Bool = false
    var borderColor: Color { .Tin }
    var backgroundColor: Color = Color(white: 0.15)
    var tickColor: Color = .gray
    var currentTickColor: Color = .red
    var labelColor: Color = .white
    var labelSize: CGFloat = 16.0
    
    let directions = [
        (abbrev: "N" ,name: "North",  degree: 0.0), (abbrev: "NE" ,name: "Northeast", degree: 45.0),
        (abbrev: "E" ,name: "East",  degree: 90.0), (abbrev: "SE" ,name: "Southeast", degree: 135.0),
        (abbrev: "S" ,name: "South",  degree: 180.0), (abbrev: "SW" ,name: "Southwest", degree: 225.0),
        (abbrev: "W" ,name: "West",  degree: 270.0), (abbrev: "NW" ,name: "Northwest", degree: 315.0)
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                // 1. Compass Face
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 300, height: 300)
                    .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                    .shadow(color: .black.opacity(0.5), radius: 15, x: 0, y: 10)
                
                // 2. High-Detail 3D Ticks and Labels
                ForEach(directions, id: \.name) { direction in
                    VStack(spacing: 8) {
                        let isActive = abs(direction.degree - normalizedAngle(currentPosition)) < 0.1
                        
                        // Triple-Layered 3D Tick
                        ZStack {
                            Capsule()
                                .fill(Color.black.opacity(0.6))
                                .frame(width: 4, height: 16)
                                .offset(x: 1.5, y: 1.5)
                                .blur(radius: 0.5)
                            
                            Capsule()
                                .fill(isActive ? currentTickColor : tickColor)
                                .overlay(
                                    Capsule()
                                        .stroke(LinearGradient(colors: [.white.opacity(isActive ? 0.8 : 0.4), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                                )
                                .frame(width: 3, height: 15)
                        }
                        
                        Text(direction.abbrev)
                            .foregroundColor(labelColor)
                            .font(.system(size: labelSize, weight: .bold, design: .monospaced))
                            .rotationEffect(.degrees(-direction.degree))
                            .padding(.top, 5)
                            .shadow(color: .black.opacity(isActive ? 0 : 0.5), radius: 1, x: 1, y: 1)
                        
                        Spacer()
                    }
                    .frame(width: 260, height: 260)
                    .rotationEffect(.degrees(direction.degree))
                }
                
                // 3. Rotating Needle & Indicator
                ZStack {
                    // Indicator Ring (Cyan Background)
                    VStack {
                        Circle()
                            .stroke(currentTickColor, lineWidth: 3)
                            .frame(width: 48, height: 48)
                            .background(Circle().fill(Color.cyan.opacity(0.15)))
                            .offset(y: 14)
                        Spacer()
                    }
                    
                    // 3D Needle Assembly
                    ZStack {
                        HStack(spacing: 0) {
                            NeedleSide(isLeft: true, isTop: true)
                                .fill(LinearGradient(colors: [.red, .red.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                            NeedleSide(isLeft: false, isTop: true)
                                .fill(LinearGradient(colors: [.red.opacity(0.7), .red.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                        }
                        HStack(spacing: 0) {
                            NeedleSide(isLeft: true, isTop: false)
                                .fill(LinearGradient(colors: [.white, Color(white: 0.9)], startPoint: .leading, endPoint: .trailing))
                            NeedleSide(isLeft: false, isTop: false)
                                .fill(LinearGradient(colors: [Color(white: 0.8), Color(white: 0.7)], startPoint: .leading, endPoint: .trailing))
                        }
                    }
                    .frame(width: 18, height: 190)
                    .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 4)
                }
                .frame(width: 260, height: 260)
                .rotationEffect(.degrees(currentPosition))
                .animation(.snappy(duration: 0.35), value: currentPosition)
                
                // 4. Center Pin
                Circle()
                    .fill(LinearGradient(colors: [.gray, .black], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 14, height: 14)
                    .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 1))
                
                // 5. Glass Lens Overlay
                Circle()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: .white.opacity(0.2), location: 0.0),
                                .init(color: .white.opacity(0.05), location: 0.3),
                                .init(color: .clear, location: 0.5),
                                .init(color: .black.opacity(0.1), location: 1.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 300, height: 300)
                    .allowsHitTesting(false)
            }
            // --- DEEP 3D Outer Border ---
            .overlay(
                // Use a ZStack to layer stroke, highlights, and shadows
                ZStack {
                    Circle()
                        .stroke(borderColor, lineWidth: 5)
                        .frame(width: 305, height: 305)
                        .shadow(color: .black, radius: 10, x: 0, y: 0) // Outer Glow

                    // Inner Highlight (Top/Left)
                    Circle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 2.5)
                        .frame(width: 305, height: 305)
                        .offset(x: -2, y: -2)
                        .mask(Circle().stroke(lineWidth: 5).frame(width: 305, height: 305))

                    // Inner Shadow (Bottom/Right)
                    Circle()
                        .stroke(Color.black.opacity(0.6), lineWidth: 2.5)
                        .frame(width: 305, height: 305)
                        .offset(x: 2, y: 2)
                        .mask(Circle().stroke(lineWidth: 5).frame(width: 305, height: 305))
                }
            )
            // -----------------------------
            .contentShape(Circle())
            .coordinateSpace(name: "compass")
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .named("compass"))
                    .onChanged { value in
                        updateAngleSeamlessly(to: value.location, center: CGPoint(x: 150, y: 150))
                    }
            )
            .sensoryFeedback(.selection, trigger: normalizedAngle(currentPosition))
            
            // 6. Combined Readout
            if showReadout {
                HStack(spacing: 10) {
                    Text("\(Int(normalizedAngle(currentPosition)))° (±22.5°)")
                    Text("・")
                    Text(currentDirectionName())
                }
                .font(.system(.headline, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .transition(.opacity.combined(with: .scale))
                .padding(.top,-15)
            }
        }
    }
    
    private func currentDirectionName() -> String {
        let norm = normalizedAngle(currentPosition)
        return directions.first(where: { abs($0.degree - norm) < 0.1 })?.name ?? "N"
    }
    
    private func updateAngleSeamlessly(to location: CGPoint, center: CGPoint) {
        let radians = atan2(location.y - center.y, location.x - center.x)
        var newDegrees = Double(radians) * 180 / .pi + 90
        while newDegrees < 0 { newDegrees += 360 }
        let snappedTarget = round(newDegrees / 45) * 45
        let target = snappedTarget.truncatingRemainder(dividingBy: 360)
        
        let currentNorm = currentPosition.truncatingRemainder(dividingBy: 360)
            
        var diff = target - currentNorm
        if diff > 180 { diff -= 360 }
        if diff < -180 { diff += 360 }
        
        let finalPosition = currentPosition + diff
        if currentPosition != finalPosition {
            currentPosition = finalPosition
        }
    }
    
    func normalizedAngle(_ angle: Double) -> Double {
        let mod = angle.truncatingRemainder(dividingBy: 360)
        return mod < 0 ? mod + 360 : mod
    }
}

public struct NeedleSide: Shape {
    var isLeft: Bool
    var isTop: Bool
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.midY
        
        if isTop {
            if isLeft {
                path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: midY))
                path.addLine(to: CGPoint(x: rect.minX, y: midY))
            } else {
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: midY))
                path.addLine(to: CGPoint(x: rect.minX, y: midY))
            }
        } else {
            if isLeft {
                path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX, y: midY))
                path.addLine(to: CGPoint(x: rect.minX, y: midY))
            } else {
                path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX, y: midY))
                path.addLine(to: CGPoint(x: rect.minX, y: midY))
            }
        }
        path.closeSubpath()
        return path
    }
}
