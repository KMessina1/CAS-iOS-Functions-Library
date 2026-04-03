/*--------------------------------------------------------------------------------------------------------------------------
    File: ext_Color.swift
  Author: Kevin Messina
 Created: 6/12/23
Modified:
 
©2023-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI

extension UIColor {
    var toColor: Color {
        Color(
            red: Double(self.cgColor.components![0]),
            green: Double(self.cgColor.components![1]),
            blue: Double(self.cgColor.components![2])
        )
    }
}

extension Color {
    var isDark: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  luminance < 0.50
    }

    var isLight: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  luminance >= 0.50
    }

    static let Aluminum = Color(UIColor(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1.0))
    static let Aqua = Color(UIColor(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
    static let Asparagus = Color(UIColor(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1))
    static let Banana = Color(UIColor(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1))
    static let Blueberry = Color(UIColor(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1))
    static let Bubblegum = Color(UIColor(red: 1, green: 0.5212053061, blue: 1, alpha: 1))
    static let Cantaloupe = Color(UIColor(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1))
    static let Carnation = Color(UIColor(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1))
    static let Cayenne = Color(UIColor(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))
    static let Clover = Color(UIColor(red: 0, green: 0.5603182912, blue: 0, alpha: 1))
    static let Eggplant = Color(UIColor(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1))
    static let Fern = Color(UIColor(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1))
    static let Flora = Color(UIColor(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1))
    static let Grape = Color(UIColor(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1))
    static let Honeydew = Color(UIColor(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1))
    static let Ice = Color(UIColor(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1))
    static let Iron = Color(UIColor(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1))
    static let Lavender = Color(UIColor(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1))
    static let Lead = Color(UIColor(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
    static let Lemon = Color(UIColor(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))
    static let Licorice = Color(UIColor(red: 0, green: 0, blue: 0, alpha: 1))
    static let Lime = Color(UIColor(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1))
    static let Magenta = Color(UIColor(red: 1, green: 0.2527923882, blue: 1, alpha: 1))
    static let Magnesium = Color(UIColor(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))
    static let Maraschino = Color(UIColor(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
    static let Maroon = Color(UIColor(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1))
    static let Mercury = Color(UIColor(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1))
    static let Midnight = Color(UIColor(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1))
    static let Mocha = Color(UIColor(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1))
    static let Moss = Color(UIColor(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1))
    static let Nickel = Color(UIColor(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1))
    static let Ocean = Color(UIColor(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1))
    static let Orchid = Color(UIColor(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1))
    static let Plum = Color(UIColor(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1))
    static let Salmon = Color(UIColor(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1))
    static let SeaFoam = Color(UIColor(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1))
    static let Silver = Color(UIColor(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1))
    static let Sky = Color(UIColor(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1))
    static let Snow = Color(UIColor(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
    static let Spindrift = Color(UIColor(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1))
    static let Spring = Color(UIColor(red: 0, green: 0.9768045545, blue: 0, alpha: 1))
    static let Steel = Color(UIColor(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1))
    static let Strawberry = Color(UIColor(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1))
    static let Tangerine = Color(UIColor(red: 1, green: 0.5781051517, blue: 0, alpha: 1))
    static let Teal = Color(UIColor(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1))
    static let Tin = Color(UIColor(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1))
    static let Tungsten = Color(UIColor(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1))
    static let Turquoise = Color(UIColor(red: 0.007843137255, green: 0.9921568627, blue: 1, alpha: 1))
}

