/*--------------------------------------------------------------------------------------------------------------------------
    File: OlympicLogo.sswift
  Author: Kevin Messina
 Created: Aug 17, 2024
Modified:

©2024 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

struct OlympicLogoView: View {
    let upperColors: [Color] = [.blue,.black,.red]
    let lowerColors: [Color] = [.yellow,.green]
    let circleWidth: CGFloat = 60
    let circleSpacing: CGFloat = 16
    var strokeWidth: CGFloat { circleWidth * 0.15 }
    let darkGreen = Color(red: 0.0/255, green: 144.0/255, blue: 81/255)
    
    var body: some View {
        HStack {
            Image(systemName: "laurel.leading")
                .resizable()
                .frame(width: circleWidth, height: circleWidth * 2.5)
                .foregroundStyle(darkGreen.gradient)
            
            VStack(spacing: -circleSpacing * 2) {
                HStack(spacing: circleSpacing) {
                    ForEach(upperColors, id: \.self) { color in
                        Circle().stroke(color, lineWidth: strokeWidth)
                            .frame(width: circleWidth)
                    }
                }
                
                HStack(spacing: circleSpacing) {
                    ForEach(lowerColors, id: \.self) { color in
                        Circle().stroke(color, lineWidth: strokeWidth)
                            .frame(width: circleWidth)
                    }
                }
            }
            
            Image(systemName: "laurel.trailing")
                .resizable()
                .frame(width: circleWidth, height: circleWidth * 2.5)
                .foregroundStyle(darkGreen.gradient)
        }
        .padding(.all,20)
        .background(.white)
    }//End Body
}

#Preview {
    OlympicLogoView()
}
