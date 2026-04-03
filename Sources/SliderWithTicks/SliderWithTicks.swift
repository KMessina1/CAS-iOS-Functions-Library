//--------------------------------------------------------------------------------------------------------------------------
//     File: SliderWithTicks.swift
//   Author: Kevin Messina
//  Created: 1/30/26
// Modified:
// 
// ©2026 Creative App Solutions, LLC. - All Rights Reserved.
//--------------------------------------------------------------------------------------------------------------------------
// NOTES:
//--------------------------------------------------------------------------------------------------------------------------

import SwiftUI
import UIKit

// MARK: - Font Extension
extension UIFont {
    static func condensedBold(ofSize size: CGFloat) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: .bold)
        let descriptor = systemFont.fontDescriptor.addingAttributes([
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold,
                UIFontDescriptor.TraitKey.width: -0.5
            ]
        ])
        return UIFont(descriptor: descriptor, size: size)
    }

    static func condensed(ofSize size: CGFloat) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: .bold)
        let descriptor = systemFont.fontDescriptor.addingAttributes([
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.width: -0.4
            ]
        ])
        return UIFont(descriptor: descriptor, size: size)
    }
}

// MARK: - Custom Slider Engine
class TickSliderEngine: UISlider {
    var trackHeight: CGFloat = 4.0
    var renderingAction: (() -> Void)?

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = trackHeight
        return rect
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        renderingAction?()
    }
}

class Coordinator: NSObject {
    var parent: TickSlider

    init(_ parent: TickSlider) {
        self.parent = parent
    }
    
    @objc func dragStarted(_ sender: UISlider) {
        if parent.showThumbBubble {
            UIView.animate(withDuration: 0.2) {
                sender.viewWithTag(101)?.viewWithTag(202)?.alpha = 1
            }
        }

        withAnimation(.smooth(duration: 0.2)) {
            self.parent.isDragging = true
        }
    }
    
    @objc func dragEnded(_ sender: UISlider) {
        UIView.animate(withDuration: 0.2) {
            sender.viewWithTag(101)?.viewWithTag(202)?.alpha = 0
        }

        withAnimation(.smooth(duration: 0.8)) {
            self.parent.isDragging = false
        }
    }
    
    @objc func valueChanged(_ sender: UISlider) {
        let totalRange = parent.range.upperBound - parent.range.lowerBound
        let tickInterval = totalRange / Double(parent.totalTicks - 1)
        let snappedValue = round((Double(sender.value) - parent.range.lowerBound) / tickInterval) * tickInterval + parent.range.lowerBound
        let steppedValue = round(Double(sender.value) / parent.step) * parent.step
        
        if parent.stickToTickMarks { sender.value = Float(snappedValue); parent.value = snappedValue }
        else { sender.value = Float(steppedValue); parent.value = steppedValue }
        
        // Update all visuals immediately after value changes
        parent.performRender(uiView: sender)
    }
}

struct TickSlider: UIViewRepresentable {
    @Binding var value: Double
    @Binding var isDragging: Bool
    @Binding var isZoomed: Bool
    @Binding var step: Double
    @Binding var totalTicks: Int

    //Input Params
    var range: ClosedRange<Double>
    var tickHeight: CGFloat = 8
    var tickColor: Color = .Tin
    var selectedTickColor: Color = .red
    var thumbTintColor: Color = .gray
    var trackColor: Color
    var tickTextSize: CGFloat = 15.0
    var bubbleTextSize: CGFloat = 15.0
    var trackHeight: CGFloat = 15.0
    var thumbSize: CGFloat = 32.0
    var showTickMarks: Bool = true
    var showTickMarkLabels: Bool = true
    var showThumbBubble: Bool = true
    var showThumb: Bool = true
    var stickToTickMarks: Bool = false
    var useGradientTrackColors: Bool = true
    var trackColorValid: Color = .green
    var trackColorWarning: Color = .yellow
    var trackColorIssue: Color = .red
    var trackRangeValid: ClosedRange<Double>
    var trackRangeWarning1: ClosedRange<Double>
    var trackRangeWarning2: ClosedRange<Double>
    var trackRangeIssue1: ClosedRange<Double>
    var trackRangeIssue2: ClosedRange<Double>

    //Working Params
    
    func makeUIView(context: Context) -> UISlider {
        let slider = TickSliderEngine()
        slider.trackHeight = trackHeight
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)
        
        if useGradientTrackColors {
            let gradientLayer = CAGradientLayer()
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.name = "trackGradient"
            slider.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        let thumbImage = createSolidThumb(
            color: UIColor(showThumb ?thumbTintColor :.clear).withAlphaComponent(0.5),
            size: thumbSize,
            hidden: !showThumb
        )
        slider.setThumbImage(thumbImage, for: .normal)
        slider.setThumbImage(thumbImage, for: .highlighted)
        
        let tickView = UIView(frame: .zero)
        tickView.isUserInteractionEnabled = false
        tickView.tag = 101
        slider.addSubview(tickView)
        
        let bubble = UILabel()
        bubble.tag = 202
        bubble.textColor = .white
        bubble.textAlignment = .center
        bubble.layer.cornerRadius = 8
        bubble.layer.masksToBounds = true
        bubble.alpha = 0
        tickView.addSubview(bubble)
        
        slider.renderingAction = { [weak slider] in
            guard let slider = slider else { return }
            self.performRender(uiView: slider)
        }
        
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.dragStarted), for: .touchDown)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.dragEnded), for: [.touchUpInside, .touchUpOutside])
        
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        if abs(Double(uiView.value) - value) > 0.001 {
            uiView.value = Float(value)
        }
        performRender(uiView: uiView)
    }

    // MARK: - Private Render Helpers
    func performRender(uiView: UISlider) {
        let trackRect = uiView.trackRect(forBounds: uiView.bounds)
        guard trackRect.width > 0 else { return }

        if let tickContainer = uiView.viewWithTag(101) {
            tickContainer.frame = uiView.bounds
            
            if useGradientTrackColors {
                applyTrackGradient(to: uiView, rect: trackRect)
            } else {
                uiView.minimumTrackTintColor = UIColor(trackColor)
                uiView.layer.sublayers?.first(where: { $0.name == "trackGradient" })?.removeFromSuperlayer()
            }
            uiView.maximumTrackTintColor = UIColor(trackColor).withAlphaComponent(0.2)
            
            // Sync thumb image with correct border
            let thumbImage = createSolidThumb(
                color: UIColor(showThumb ?thumbTintColor :.clear).withAlphaComponent(0.5),
                size: thumbSize,
                hidden: !showThumb
            )
            uiView.setThumbImage(thumbImage, for: .normal)
            uiView.setThumbImage(thumbImage, for: .highlighted)
            
            if let bubble = tickContainer.viewWithTag(202) as? UILabel {
                bubble.isHidden = !showThumbBubble
                updateBubble(bubble, in: uiView, value: Double(uiView.value))
            }
            
            tickContainer.subviews.filter({ $0.tag != 202 }).forEach { $0.removeFromSuperview() }
            if showTickMarks { renderTicks(in: tickContainer, slider: uiView, trackRect: trackRect) }
        }
    }

    private func renderTicks(in container: UIView, slider: UISlider, trackRect: CGRect) {
//        let midIndex = totalTicks / 2
        let yOffset = trackRect.maxY + 12.0
        let totalRangeValue = range.upperBound - range.lowerBound
        
        for i in 0..<totalTicks {
            let progress = CGFloat(i) / CGFloat(totalTicks - 1)
            let xPosition = trackRect.minX + (progress * trackRect.width)
            let tickValue = range.lowerBound + (Double(i) * (totalRangeValue / Double(totalTicks - 1)))
            
            let tickInterval = totalRangeValue / Double(totalTicks - 1)
            let isSelected = abs(tickValue - Double(slider.value)) < (tickInterval / 2.0)
            var hasLabel: Bool {
                if isZoomed {
                    switch totalTicks {
                    case 0...11: return (i % 4 == 0)
                    case 12...41: return (i % 4 == 0)
                    default: return false
                    }
                }else{
                    switch totalTicks {
                    case 0...11: return (i % 2 == 0)
                    case 12...41: return (i % 2 == 0)
                    default: return false
                    }
                }
            }
            
            let targetWidth: CGFloat = isSelected ? 6.0 : 2.0
            let targetHeight: CGFloat = isSelected ? tickHeight * 1.2 : (hasLabel ? tickHeight : tickHeight * 0.7)
            
            let tick = UIView(frame: CGRect(x: xPosition - (targetWidth / 2), y: yOffset, width: targetWidth, height: targetHeight))
            tick.backgroundColor = isSelected ? UIColor(selectedTickColor) : UIColor(tickColor)
            tick.layer.cornerRadius = targetWidth / 2
            container.addSubview(tick)

            if showTickMarkLabels && hasLabel {
                let label = UILabel()
                label.text = formatValue(tickValue)
                label.textColor = UIColor(tickColor)
                label.font = UIFont.condensedBold(ofSize: tickTextSize)
                label.sizeToFit()
                let labelY = yOffset + (tickHeight * 1.2) + 1
                if i == 0 { label.frame.origin = CGPoint(x: trackRect.minX, y: labelY) }
                else if i == totalTicks - 1 { label.frame.origin = CGPoint(x: trackRect.maxX - label.frame.width, y: labelY) }
                else { label.center = CGPoint(x: xPosition, y: labelY + (label.frame.height / 2)) }
                container.addSubview(label)
            }
        }
    }

    private func updateBubble(_ label: UILabel, in slider: UISlider, value: Double) {
        label.text = " \(formatValue(value)) "
        label.font = UIFont.condensed(ofSize: bubbleTextSize)
        label.sizeToFit()
        label.frame.size.width += (bubbleTextSize * 0.7)
        label.frame.size.height = bubbleTextSize * 1.6
        label.backgroundColor = getActiveRangeColor(for: value)
        label.textColor = .black
        let trackRect = slider.trackRect(forBounds: slider.bounds)
        let thumbRect = slider.thumbRect(forBounds: slider.bounds, trackRect: trackRect, value: Float(value))
        label.center = CGPoint(x: thumbRect.midX, y: thumbRect.minY - (thumbSize / 2) - (bubbleTextSize * 0.8))
    }

    private func getActiveRangeColor(for val: Double) -> UIColor {
        if !useGradientTrackColors { return UIColor(trackColor) }
        if trackRangeIssue1.contains(val) || trackRangeIssue2.contains(val) { return UIColor(trackColorIssue) }
        if trackRangeWarning1.contains(val) || trackRangeWarning2.contains(val) { return UIColor(trackColorWarning) }
        if trackRangeValid.contains(val) { return UIColor(trackColorValid) }
        return UIColor(trackColor)
    }

    private func applyTrackGradient(to slider: UISlider, rect: CGRect) {
        let configs = [
            (range: trackRangeValid, color: trackColorValid),
            (range: trackRangeWarning1, color: trackColorWarning),
            (range: trackRangeWarning2, color: trackColorWarning),
            (range: trackRangeIssue1, color: trackColorIssue),
            (range: trackRangeIssue2, color: trackColorIssue)
        ].sorted { $0.range.lowerBound < $1.range.lowerBound }

        let colors = configs.map { UIColor($0.color).cgColor }
        let totalRange = range.upperBound - range.lowerBound
        let locations = configs.map { NSNumber(value: ($0.range.lowerBound - range.lowerBound) / totalRange) }

        if let gradient = slider.layer.sublayers?.first(where: { $0.name == "trackGradient" }) as? CAGradientLayer {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradient.frame = rect
            gradient.colors = colors
            gradient.locations = locations
            gradient.cornerRadius = rect.height / 2
            let mask = CAShapeLayer()
            let activeWidth = CGFloat((Double(slider.value) - range.lowerBound) / totalRange) * rect.width
            mask.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: activeWidth, height: rect.height), cornerRadius: rect.height / 2).cgPath
            gradient.mask = mask
            slider.minimumTrackTintColor = .clear
            CATransaction.commit()
        }
    }

    private func formatValue(_ val: Double) -> String {
        if val >= 1000 {
            let kValue = val / 1000.0
            return kValue.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0fk", kValue) : String(format: "%.1fk", kValue)
        }
        return String(format: "%.0f", val)
    }

    // Helper to generate a solid color thumb with a white stroke
    private func createSolidThumb(color: UIColor, size: CGFloat, hidden: Bool) -> UIImage {
        let strokeWidth: CGFloat = hidden ?0.0 :2.0
        return UIGraphicsImageRenderer(size: CGSize(width: size, height: size)).image { ctx in
            // Fill
            color.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(x: 0, y: 0, width: size, height: size))
            
            // Stroke
            ctx.cgContext.setStrokeColor(hidden ?UIColor.clear.cgColor :UIColor.white.cgColor)
            ctx.cgContext.setLineWidth(strokeWidth)
            // Inset the stroke path so it stays within the image boundary
            let strokeRect = CGRect(x: strokeWidth / 2, y: strokeWidth / 2, width: size - strokeWidth, height: size - strokeWidth)
            ctx.cgContext.strokeEllipse(in: strokeRect)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }
}

#Preview {
    @Previewable @State var userTemp: Double = 59
    @Previewable @State var isDragging: Bool = false
    @Previewable @State var isZoomed: Bool = false
    @Previewable @State var step: Double = 100.0
    @Previewable @State var ticks: Int = 11

    let CT = CurrentTheme().getThemeFromUserStds()
    let range: ClosedRange<Double> = -20...120
//    let step = Double((range.upperBound - (range.lowerBound + 1)) / 21)
    
    VStack(spacing:75) {
        TickSlider(
            value: $userTemp,
            isDragging: $isDragging,
            isZoomed: $isZoomed,
            step: $step,
            totalTicks: $ticks,
            range: range,
            tickHeight: 12,
            tickColor: .Tin,
            selectedTickColor: .red,
            thumbTintColor: .red,
            trackColor: CT.title,
            tickTextSize: 15,
            bubbleTextSize: 15,
            trackHeight: 15,
            thumbSize: 32,
            showTickMarks: true,
            showTickMarkLabels: true,
            showThumbBubble: true,
            showThumb: true,
            stickToTickMarks: true,
            useGradientTrackColors: true,
            trackColorValid: .green,
            trackColorWarning: .yellow,
            trackColorIssue: .red,
            trackRangeValid: 20...94,
            trackRangeWarning1: 0...19,
            trackRangeWarning2: 95...109,
            trackRangeIssue1: range.lowerBound ... 0,
            trackRangeIssue2: 110...range.upperBound
        )
        .disabled(true)
    }
    .padding(.horizontal,30)
}

