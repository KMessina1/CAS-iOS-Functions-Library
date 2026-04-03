/*--------------------------------------------------------------------------------------------------------------------------
    File: TapeMeasurePicker.swift
  Author: Kevin Messina
 Created: 8/17/24
Modified:
 
©2024 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

///Sample Usage
///
///struct ContentView: View {
///    @State var count: Int = 0
///    var body:some View {
///        WheelPicker(count: $count)
///
///        Text("Count: \(count)")
///    }
///}
public struct WheelPicker: View {
    @Environment(\._wheelPicker_segmentWidth) private var segmentWidth
    
    @Binding var count: Int
    
    var values: ClosedRange<Int>
    var spacing: Double
    var steps: Int
    
    public init(
        count: Binding<Int>,
        values: ClosedRange<Int> = 0...100,
        spacing: Double = 8.0,
        steps: Int = 5
    ) {
        _count = count
        self.values = values
        self.spacing = spacing
        self.steps = steps
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: spacing) {
                        ForEach(values, id: \.self) { index in
                            let isPrimary = index % steps == .zero
                            
                            VStack(spacing: 40.0) {
                                Rectangle()
                                    .frame(
                                        width: segmentWidth,
                                        height: isPrimary ? 20.0 : 8.0
                                    )
                                    .frame(
                                        maxHeight: 20.0,
                                        alignment: .top
                                    )
                                Rectangle()
                                    .frame(
                                        width: segmentWidth,
                                        height: isPrimary ? 20.0 : 8.0
                                    )
                                    .frame(
                                        maxHeight: 20.0,
                                        alignment: .bottom
                                    )
                            }
                            .scrollTransition(
                                axis: .horizontal,
                                transition: { content, phase in
                                    content
                                        .opacity(phase == .topLeading ? 0.2 : 1.0)
                                }
                            )
                            .overlay {
                                if isPrimary {
                                    Text("\(index)")
                                        .font(.system(size: 24.0, design: .monospaced))
                                        .fixedSize()
                                        .scrollTransition(
                                            axis: .horizontal,
                                            transition: { content, phase in
                                                content
                                                    .opacity(phase.isIdentity ? 10.0 : 0.4)
                                            }
                                        )
                                }
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .overlay {
                    Rectangle()
                        .fill(.red)
                        .frame(width: segmentWidth)
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding(.horizontal, proxy.size.width / 2.0)
                .scrollTargetBehavior(.snap(step: spacing + segmentWidth))
                .scrollPosition(
                    id: .init(
                        get: {
                            count
                        },
                        set: { value, transaction in
                            if let value {
                                count = value
                            }
                        }
                    )
                )
            }
        }
        .frame(width: 280.0, height: 80.0)
        .sensoryFeedback(.selection, trigger: count)
    }
}

#Preview {
    WheelPicker(count: .constant(0))
}
