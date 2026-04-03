/*--------------------------------------------------------------------------------------------------------------------------
     File: Fonts.swift
   Author: Kevin Messina
  Created: Apr 18, 2020
 Modified: Aug 23. 2024
 
 ©2020-2026 Creative App Solutions, LLC. - All Rights Reserved.
 ----------------------------------------------------------------------------------------------------------------------------
 NOTES:
 
 2025_04_13 - Updated SimPrint structure.
 2024_08_23 - Converted Structs to enum's.
 --------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI

// MARK: - *** FONT DEFINITIONS ***
/// FontName
///
/// Usage: .font(Font.custom(FontName.AcademyEngravedLET.regular.rawValue, size: 24))
///
struct FontName: RawRepresentable {
    var rawValue: String
    
    func printAllNamesToConsole() {
        for family: String in UIFont.familyNames {
            simPrint("\(family)", action: .info, log: LFFL())
            
            for names: String in UIFont.fontNames(forFamilyName: family) {
                simPrint("\(names)", action: .detail_1, log: LFFL())
            }
        }
    }

    enum AcademyEngravedLET: String {
        case regular = "AcademyEngravedLetPlain"
    }

    enum AlNile: String {
        case regular = "AlNile"
        case bold = "AlNile-Bold"
    }
    
    enum AmericanTypewriter: String {
        case regular = "AmericanTypewriter"
        case bold = "AmericanTypewriter-Bold"
        case light = "AmericanTypewriter-Light"

        enum Condensed: String {
            case regular = "AmericanTypewriter-Condensed"
            case bold = "AmericanTypewriter-CondensedBold"
            case light = "AmericanTypewriter-CondensedLight"
        }
    }
    
    enum AppleColorEmoji: String {
        case regular = "AppleColorEmoji"
    }
    
    enum AppleSDGothicNeo: String {
        case regular = "AppleSDGothicNeo-Regular"
        case medium = "AppleSDGothicNeo-Medium"
        case bold = "AppleSDGothicNeo-Bold"
        case thin = "AppleSDGothicNeo-Thin"
        case light = "AppleSDGothicNeo-Light"
        case ultraLight = "AppleSDGothicNeo-UltraLight"
        case semibold = "AppleSDGothicNeo-SemiBold"
    }
    
    enum Arial: String {
        case regular = "ArialMT"
        case bold = "Arial-BoldMT"

        enum Italic: String {
            case regular = "Arial-ItalicMT"
            case bold = "Arial-BoldItalicMT"
        }
    }
    
    enum ArialHebrew: String {
        case regular = "ArialHebrew"
        case bold = "ArialHebrew-Bold"
        case light = "ArialHebrew-Light"
    }
    
    enum ArialRoundedMTBold: String {
        case regular = "ArialRoundedMTBold"
    }
    
    enum Avenir: String {
        case italic = "Avenir-Oblique"
        case regular = "Avenir-Roman"

        enum Black: String {
            case regular = "Avenir-Black"
            case italic = "Avenir-BlackOblique"
        }

        enum Book: String {
            case regular = "Avenir-Book"
            case italic = "Avenir-BookOblique"
        }

        enum Heavy: String {
            case regular = "Avenir-Heavy"
            case italic = "Avenir-HeavyOblique"
        }

        enum Light: String {
            case regular = "Avenir-Light"
            case italic = "Avenir-LightOblique"
        }

        enum Medium: String {
            case regular = "Avenir-Medium"
            case italic = "Avenir-MediumOblique"
        }
    }
    
    enum AvenirNext: String {
        enum Bold: String {
            case regular = "AvenirNext-Bold"
            case italic = "AvenirNext-BoldItalic"
        }

        enum DemiBold: String {
            case regular = "AvenirNext-DemiBold"
            case italic = "AvenirNext-DemiBoldItalic"
        }

        enum Heavy: String {
            case regular = "AvenirNext-Heavy"
            case italic = "AvenirNext-HeavyItalic"
        }

        case italic = "AvenirNext-Italic"
        case regular = "AvenirNext-Regular"

        enum Medium: String {
            case regular = "AvenirNext-Medium"
            case italic = "AvenirNext-MediumItalic"
        }

        enum UltraLight: String {
            case regular = "AvenirNext-UltraLight"
            case italic = "AvenirNext-UltraLightItalic"
        }
    }
    
    enum AvenirNextCondensed: String {
        enum Bold: String {
            case regular = "AvenirNextCondensed-Bold"
            case italic = "AvenirNextCondensed-BoldItalic"
        }
        
        enum DemiBold: String {
            case regular = "AvenirNextCondensed-DemiBold"
            case italic = "AvenirNextCondensed-DemiBoldItalic"
        }
        
        enum Heavy: String {
            case regular = "AvenirNextCondensed-Heavy"
            case italic = "AvenirNextCondensed-HeavyItalic"
        }
        
        case italic = "AvenirNextCondensed-Italic"
        case regular = "AvenirNextCondensed-Regular"
        
        enum Medium: String {
            case regular = "AvenirNextCondensed-Medium"
            case italic = "AvenirNextCondensed-MediumItalic"
        }
        
        enum UltraLight: String {
            case regular = "AvenirNextCondensed-UltraLight"
            case italic = "AvenirNextCondensed-UltraLightItalic"
        }
    }
    
    enum BanglaSangamMN: String {
        case regular = "BanglaSangamMN"
        case bold = "BanglaSangamMN-Bold"
    }
    
    enum Baskerville: String {
        enum Bold: String {
            case regular = "Baskerville-Bold"
            case italic = "Baskerville-BoldItalic"
        }
    
        case italic = "Baskerville-Italic"
        
        enum SemiBold: String {
            case regular = "Baskerville-SemiBold"
            case italic = "Baskerville-SemiBoldItalic"
        }
    }
    
    enum BodoniOrnaments: String {
        case regular = "BodoniOrnaments"
    }
    
    enum Bodoni72: String {
        case bold = "BodoniSvtyTwoITCTT-Bold"
        
        enum Book: String {
            case regular = "BodoniSvtyTwoITCTT-Book"
            case italic = "BodoniSvtyTwoITCTT-BookItalic"
        }
    }
    
    enum Bodoni72Oldstyle: String {
        case bold = "BodoniSvtyTwoOSITCTT-Bold"
        
        enum Book: String {
            case regular = "BodoniSvtyTwoOSITCTT-Book"
            case italic = "BodoniSvtyTwoOSITCTT-BookItalic"
        }
    }
    
    enum Bodoni72Smallcaps: String {
        case regular = "BodoniSvtyTwoSCITCTT-Book"
    }
    
    enum BradleyHand: String {
        case regular = "BradleyHandITCTT-Bold"
    }
    
    enum ChalkboardSE: String {
        case regular = "ChalkboardSE-Regular"
        case bold = "ChalkboardSE-Bold"
        case light = "ChalkboardSE-Light"
    }
    
    enum Chalkduster: String {
        case regular = "Chalkduster"
    }
    
    enum Cochin: String {
        case regular = "Cochin"
        case italic = "Cochin-Italic"
        
        enum Bold: String {
            case italic = "Cochin-BoldItalic"
        }
    }
    
    enum Copperplate: String {
        case regular = "Copperplate"
        case bold = "Copperplate-Bold"
        case light = "Copperplate-Italic"
    }
    
    enum Courier: String {
        case regular = "Courier"
        case italic = "Courier-Oblique"

        enum Bold: String {
            case regular = "Courier-Bold"
            case italic = "Courier-BoldOblique"
        }
    }

    enum CourierNew: String {
        case regular = "CourierNewPSMT"
        case italic = "CourierNewPS-ItalicMT"
        
        enum Bold: String {
            case regular = "CourierNewPS-BoldMT"
            case italic = "CourierNewPS-ItalicMT"
        }
    }
    
    enum DIN_Alternate: String {
        case bold = "DINAlternate-Bold"
    }
    
    enum DIN_Condensed: String {
        case bold = "DINCondensed-Bold"
    }
    
    enum Damascus: String {
        case regular = "Damascus"
        case bold = "DamascusBold"
        case light = "DamascusLight"
        case medium = "DamascusMedium"
        case semiBold = "DamascusSemiBold"
    }
    
    enum DevanagariSangamMN: String {
        case regular = "DevanagariSangamMN"
        case bold = "DevanagariSangamMN-Bold"
    }
    
    enum Didot: String {
        case regular = "Didot"
        case bold = "Didot-Bold"
        case italic = "Didot-Italic"
    }
    
    enum DiwanMishafi: String {
        case regular = "DiwanMishafi"
    }
    
    enum EuphemiaUCAS: String {
        case regular = "EuphemiaUCAS"
        case bold = "EuphemiaUCAS-Bold"
        case italic = "EuphemiaUCAS-Italic"
    }
    
    enum Farah: String {
        case regular = "Farah"
    }
    
    enum Futura {
        enum Condensed: String {
            case regular = "Futura-CondensedMedium"
            case italic = "Futura-CondensedExtraBold"
        }
        
        enum Medium: String {
            case regular = "Futura-Medium"
            case italic = "Futura-MediumItalic"
        }
    }
    
    enum GeezaPro: String {
        case regular = "GeezaPro"
        case bold = "GeezaPro-Bold"
    }
    
    enum Georgia: String {
        case regular = "Georgia"
        case bold = "Georgia-Bold"
        
        enum Italic: String {
            case regular = "Georgia-Italic"
            case bold = "Georgia-BoldItalic"
        }
    }
    
    enum GilSans: String {
        case regular = "GilSans"
        case italic = "GilSans-Italic"
        
        enum SemiBold: String {
            case regular = "GillSans-SemiBold"
            case bold = "GillSans-SemiBoldItalic"
        }
        
        enum Bold: String {
            case regular = "GillSans-Bold"
            case bold = "GillSans-BoldItalic"
            case ultraBold = "GillSans-UltraBold"
        }
        
        enum Light: String {
            case regular = "GillSans-Light"
            case bold = "GillSans-LightItalic"
        }
    }
    
    enum GujaratiSangamMN: String {
        case regular = "GujaratiSangamMN"
        case italic = "GujaratiSangamMN-Bold"
    }
    
    enum GurmukhiMN: String {
        case regular = "GurmukhiMN"
        case italic = "GurmukhiMN-Bold"
    }
    
    enum HeitiSC: String {
        case light = "STHeitiSC-Light"
        case medium = "STHeitiSC-Medium"
    }
    
    enum HeitiTC: String {
        case light = "STHeitiTC-Light"
        case medium = "STHeitiTC-Medium"
    }
    
    enum Helvetica: String {
        case regular = "Helvetica"
        case italic = "Helvetica-Oblique"
        
        enum Bold: String {
            case bold = "Helvetica-Bold"
            case italic = "Helvetica-BoldItalic"
        }
        
        enum Light: String {
            case regular = "Helvetica-Light"
            case bold = "Helvetica-LightItalic"
        }
    }
    
    enum HelveticaNeue: String {
        case regular = "HelveticaNeue"
        case italic = "HelveticaNeue-Italic"
        
        enum Bold: String {
            case bold = "HelveticaNeue-Bold"
            case italic = "HelveticaNeue-BoldItalic"
        }
        
        enum Condensed: String {
            case black = "HelveticaNeue-CondensedBlack"
            case bold = "HelveticaNeue-CondensedBold"
        }
        
        enum Light: String {
            case regular = "HelveticaNeue-Light"
            case italic = "HelveticaNeue-LightItalic"
        }
        
        enum Medium: String {
            case regular = "HelveticaNeue-Medium"
            case italic = "HelveticaNeue-MediumItalic"
        }
        
        enum UltraLight: String {
            case regular = "HelveticaNeue-UltraLight"
            case italic = "HelveticaNeue-UltraLightItalic"
        }
        
        enum Thin: String {
            case regular = "HelveticaNeue-Thin"
            case italic = "HelveticaNeue-ThinItalic"
        }
    }
    
    enum HiraginoMinchoProN: String {
        case regular = "HiraMinProN-W3"
        case bold = "HiraMinProN-W6"
    }
    
    enum HiraginoSans: String {
        case regular = "HiraginoSans-W3"
        case bold = "HiraginoSans-W6"
    }
    
    enum HoeflerText: String {
        case regular = "HoeflerText-Regular"
        case italic = "HoeflerText-Italic"
        
        enum Black: String {
            case regular = "HoeflerText-Black"
            case italic = "HoeflerText-BlackItalic"
        }
    }
    
    enum IowanOldStyle: String {
        case regular = "IowanOldStyle-Roman"
        case italic = "IowanOldStyle-Italic"
        
        enum Bold: String {
            case regular = "IowanOldStyle-Bold"
            case italic = "IowanOldStyle-BoldItalic"
        }
    }
    
    enum Kailasa: String {
        case regular = "Kailasa"
        case bold = "Kailasa-Bold"
    }
    
    enum KannadaSangamMN: String {
        case regular = "KannadaSangamMN"
        case bold = "KannadaSangamMN-Bold"
    }
    
    enum KhmerSangamMN: String {
        case regular = "KhmerSangamMN"
    }
    
    enum KohinoorBangla: String {
        case light = "KohinoorBangla-Light"
        case regular = "KohinoorBangla-Regular"
        case semiBold = "KohinoorBangla-SemiBold"
    }
    
    enum KohinoorTelugu: String {
        case light = "KohinoorTelugu-Light"
        case regular = "KohinoorTelugu-Regular"
        case semiBold = "KohinoorTelugu-SemiBold"
    }
    
    enum LaoSangamMN: String {
        case light = "LaoSangamMN"
    }
    
    enum MalayalamSangamMN: String  {
        case regular = "MalayalamSangamMN"
        case bold = "MalayalamSangamMN-Bold"
    }
    
    enum Menlo: String {
        case regular = "Menlo-Regular"
        case italic = "Menlo-Italic"

        enum Bold: String {
            case regular = "Menlo-Bold"
            case italic = "Menlo-BoldItalic"
        }
    }
    
    enum Marion: String {
        case regular = "Marion-Regular"
        case bold = "Marion-Bold"
        case italic = "Marion-Italic"
    }
    
    enum MarkerFelt: String {
        case thin = "MarkerFelt-Thin"
        case wide = "MarkerFelt-Wide"
    }
    
    enum Noteworthy: String {
        case light = "Noteworthy-Light"
        case bold = "Noteworthy-Bold"
    }
    
    enum NewYork {
        enum ExtraLarge: String {
            case medium = "NewYorkExtraLarge-Medium"
            case mediumItalic = "NewYorkExtraLarge-MediumItalic"
            case regular = "NewYorkExtraLarge-Regular"
            case regularItalic = "NewYorkExtraLarge-RegularItalic"
            case black = "NewYorkExtraLarge-Black"
            case blackItalic = "NewYorkExtraLarge-BlackItalic"
            case bold = "NewYorkExtraLarge-Bold"
            case boldItalic = "NewYorkExtraLarge-BoldItalic"
            case heavy = "NewYorkExtraLarge-Heavy"
            case heavyItalic = "NewYorkExtraLarge-HeavyItalic"
            case semiBold = "NewYorkExtraLarge-SemiBold"
            case semiBoldItalic = "NewYorkExtraLarge-SemiBoldItalic"
        }
        
        enum Large: String {
            case medium = "NewYorkLarge-Medium"
            case mediumItalic = "NewYorkLarge-MediumItalic"
            case regular = "NewYorkLarge-Regular"
            case regularItalic = "NewYorkLarge-RegularItalic"
            case black = "NewYorkLarge-Black"
            case blackItalic = "NewYorkLarge-BlackItalic"
            case bold = "NewYorkLarge-Bold"
            case boldItalic = "NewYorkLarge-BoldItalic"
            case heavy = "NewYorkLarge-Heavy"
            case heavyItalic = "NewYorkLarge-HeavyItalic"
            case semiBold = "NewYorkLarge-SemiBold"
            case semiBoldItalic = "NewYorkLarge-SemiBoldItalic"
        }
        
        enum Medium: String {
            case medium = "NewYorkMedium-Medium"
            case mediumItalic = "NewYorkMedium-MediumItalic"
            case regular = "NewYorkMedium-Regular"
            case regularItalic = "NewYorkMedium-RegularItalic"
            case black = "NewYorkMedium-Black"
            case blackItalic = "NewYorkMedium-BlackItalic"
            case bold = "NewYorkMedium-Bold"
            case boldItalic = "NewYorkMedium-BoldItalic"
            case heavy = "NewYorkMedium-Heavy"
            case heavyItalic = "NewYorkMedium-HeavyItalic"
            case semiBold = "NewYorkMedium-SemiBold"
            case semiBoldItalic = "NewYorkMedium-SemiBoldItalic"
        }
        
        enum Small: String {
            case medium = "NewYorkSmall-Medium"
            case mediumItalic = "NewYorkSmall-MediumItalic"
            case regular = "NewYorkSmall-Regular"
            case regularItalic = "NewYorkSmall-RegularItalic"
            case black = "NewYorkSmall-Black"
            case blackItalic = "NewYorkSmall-BlackItalic"
            case bold = "NewYorkSmall-Bold"
            case boldItalic = "NewYorkSmall-BoldItalic"
            case heavy = "NewYorkSmall-Heavy"
            case heavyItalic = "NewYorkSmall-HeavyItalic"
            case semiBold = "NewYorkSmall-SemiBold"
            case semiBoldItalic = "NewYorkSmall-SemiBoldItalic"
        }
    }
    
    enum Optima: String {
        case regular = "Optima-Regular"
        case italic = "Optima-Italic"
        case extraBlack = "Optima-ExtraBlack"
        
        enum Bold: String {
            case regular = "Optima-Bold"
            case bold = "Optima-BoldItalic"
        }
    }
    
    enum OriyaSangamMN: String {
        case light = "OriyaSangamMN"
        case bold = "OriyaSangamMN-Bold"
    }
    
    enum Palatino: String {
        case regular = "Palatino-Roman"
        case italic = "Palatino-Italic"
        
        enum Bold: String {
            case regular = "Palatino-Bold"
            case bold = "Palatino-BoldItalic"
        }
    }
    
    enum Papyrus: String {
        case regular = "Papyrus"
        case condensed = "Papyrus-Condensed"
    }
    
    enum PartyLET: String {
        case regular = "PartyLetPlain"
    }
    
    enum PingFangHK: String {
        case ultraLight = "PingFangHK-Ultralight"
        case Light = "PingFangHK-Light"
        case thin = "PingFangHK-Thin"
        case regular = "PingFangHK-Regular"
        case medium = "PingFangHK-Medium"
        case semiBold = "PingFangHK-SemiBold"
    }
    
    enum PingFangSC: String {
        case ultraLight = "PingFangSC-Ultralight"
        case Light = "PingFangSC-Light"
        case thin = "PingFangSC-Thin"
        case regular = "PingFangSC-Regular"
        case medium = "PingFangSC-Medium"
        case semiBold = "PingFangSC-SemiBold"
    }
    
    enum PingFangTC: String {
        case ultraLight = "PingFangTC-Ultralight"
        case Light = "PingFangTC-Light"
        case thin = "PingFangTC-Thin"
        case regular = "PingFangTC-Regular"
        case medium = "PingFangTC-Medium"
        case semiBold = "PingFangTC-Semibold"
    }
    
    enum SF {
        // Default for WatchOS
        enum Compact {
            enum Display: String {
                case light = "SFCompactDisplay-Light"
                case medium = "SFCompactDisplay-Medium"
                case regular = "SFCompactDisplay-Regular"
                case thin = "SFCompactDisplay-Thin"
                case ultraLight = "SFCompactDisplay-Ultralight"
                case black = "SFCompactDisplay-Black"
                case bold = "SFCompactDisplay-Bold"
                case heavy = "SFCompactDisplay-Heavy"
                case semiBold = "SFCompactDisplay-Semibold"
            }
            
            enum Rounded: String {
                case light = "SFCompactRounded-Light"
                case medium = "SFCompactRounded-Medium"
                case regular = "SFCompactRounded-Regular"
                case thin = "SFCompactRounded-Thin"
                case ultraLight = "SFCompactRounded-Ultralight"
                case black = "SFCompactRounded-Black"
                case bold = "SFCompactRounded-Bold"
                case heavy = "SFCompactRounded-Heavy"
                case semiBold = "SFCompactRounded-Semibold"
            }
            
            enum Text: String {
                case light = "SFCompactText-Light"
                case medium = "SFCompactText-Medium"
                case regular = "SFCompactText-Regular"
                case thin = "SFCompactText-Thin"
                case ultraLight = "SFCompactText-Ultralight"
                case italic = "SFCompactText-Italic"
                case lightItalic = "SFCompactText-LightItalic"
                case mediumItalic = "SFCompactText-MediumItalic"
                case thiItalic = "SFCompactText-ThinItalic"
                case ultraLightItalic = "SFCompactText-UltralightItalic"
                case black = "SFCompactText-Black"
                case bold = "SFCompactText-Bold"
                case heavy = "SFCompactText-Heavy"
                case semiBold = "SFCompactText-Semibold"
                case blackItalic = "SFCompactText-BlackItalic"
                case boldItalic = "SFCompactText-BoldItalic"
                case heavyItalic = "SFCompactText-HeavyItalic"
                case semiBoldItalic = "SFCompactText-SemiboldItalic"
            }
        }

        // Mono Spaced
        enum Mono: String {
            case light = "SFMono-Light"
            case medium = "SFMono-Medium"
            case regular = "SFMono-Regular"
            case lightItalic = "SFMono-LightItalic"
            case mediumItalic = "SFMono-MediumItalic"
            case regularItalic = "SFMono-RegularItalic"
            case bold = "SFMono-Bold"
            case heavy = "SFMono-Heavy"
            case semiBold = "SFMono-Semibold"
            case boldItalic = "SFMono-BoldItalic"
            case heavyItalic = "SFMono-HeavyItalic"
            case semiBoldItalic = "SFMono-SemiboldItalic"
        }
        
        // Default for iOS, MacOS, & tvOS
        enum Pro {
            enum Display: String {
                case light = "SFProDisplay-Light"
                case medium = "SFProDisplay-Medium"
                case regular = "SFProDisplay-Regular"
                case thin = "SFProDisplay-Thin"
                case ultraLight = "SFProDisplay-Ultralight"
                case lightItalic = "SFProDisplay-LightItalic"
                case mediumItalic = "SFProDisplay-MediumItalic"
                case regularItalic = "SFProDisplay-RegularItalic"
                case thinItalic = "SFProDisplay-ThinItalic"
                case ultralightItalic = "SFProDisplay-UltralightItalic"
                case black = "SFProDisplay-Black"
                case bold = "SFProDisplay-Bold"
                case heavy = "SFProDisplay-Heavy"
                case semiBold = "SFProDisplay-Semibold"
                case blackItalic = "SFProDisplay-BlackItalic"
                case boldItalic = "SFProDisplay-BoldItalic"
                case heavyItalic = "SFProDisplay-HeavyItalic"
                case semiboldItalic = "SFProDisplay-SemiboldItalic"
            }
            
            enum Rounded: String {
                case light = "SFProRounded-Light"
                case medium = "SFProRounded-Medium"
                case regular = "SFProRounded-Regular"
                case thin = "SFProRounded-Thin"
                case ultraLight = "SFProRounded-Ultralight"
                case black = "SFProRounded-Black"
                case bold = "SFProRounded-Bold"
                case heavy = "SFProRounded-Heavy"
                case semiBold = "SFProRounded-Semibold"
            }
            
            enum Text: String {
                case light = "SFProText-Light"
                case medium = "SFProText-Medium"
                case regular = "SFProText-Regular"
                case thin = "SFProText-Thin"
                case ultraLight = "SFProText-Ultralight"
                case italic = "SFProText-Italic"
                case lightItalic = "SFProText-LightItalic"
                case mediumItalic = "SFProText-MediumItalic"
                case thiItalic = "SFProText-ThinItalic"
                case ultraLightItalic = "SFProText-UltralightItalic"
                case black = "SFProText-Black"
                case bold = "SFProText-Bold"
                case heavy = "SFProText-Heavy"
                case semiBold = "SFProText-Semibold"
                case blackItalic = "SFProText-BlackItalic"
                case boldItalic = "SFProText-BoldItalic"
                case heavyItalic = "SFProText-HeavyItalic"
                case semiBoldItalic = "SFProText-SemiboldItalic"
            }
        }
    }
    
    enum SavoyeLet: String {
        case regular = "SavoyeLetPlain"
    }
    
    enum SinhalaSangamMN: String {
        case regular = "SinhalaSangamMN"
        case bold = "SinhalaSangamMN-Bold"
    }
    
    enum SnellRoundhand: String {
        case regular = "SnellRoundhand"
        case bold = "SnellRoundhand-Bold"
        case black = "SnellRoundhand-Black"
    }
    
    enum Symbol: String {
        case regular = "Symbol"
    }
    
    enum TamilSangamMN: String {
        case regular = "TamilSangamMN"
        case bold = "TamilSangamMN-Bold"
    }
    
    enum TeluguSangamMN: String {
        case regular = "TeluguSangamMN"
        case bold = "TeluguSangamMN-Bold"
    }
    
    enum Thonburi: String {
        case regular = "Thonburi"
        case bold = "Thonburi-Bold"
        case light = "Thonburi-Light"
    }
    
    enum TimesNewRoman: String {
        case regular = "TimesNewRomanPSMT"
        case italic = "TimesNewRomanPS-ItalicMT"
      
        enum Bold: String {
            case regular = "TimesNewRomanPS-BoldMT"
            case italic = "TimesNewRomanPS-BoldItalicMT"
        }
    }
    
    enum TrebuchetMS: String {
        case regular = "TrebuchetMS"
        case italic = "TrebuchetMS-Italic"

        enum Bold: String {
            case regular = "TrebuchetMS-Bold"
            case italic = "TrebuchetMS-BoldItalic"
        }
    }
    
    enum Verdana: String {
        case regular = "Verdana"
        case italic = "Verdana-Italic"

        enum Bold: String {
            case regular = "Verdana-Bold"
            case italic = "Verdana-BoldItalic"
        }
    }
    
    enum ZapfDingbats: String {
        case regular = "ZapfDingbatsITC"
    }
    
    enum Zapfino: String {
        case regular = "Zapfino"
    }
}

