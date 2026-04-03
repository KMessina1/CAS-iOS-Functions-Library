/*--------------------------------------------------------------------------------------------------------------------------
    File: ext_UIImage.swift
  Author: Kevin Messina
 Created: Sep 4, 2025
Modified:
 
©2025-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
 
--------------------------------------------------------------------------------------------------------------------------*/

import UIKit

extension UIImage {
    func thumbnail(width: CGFloat) -> UIImage? {
        guard size.width > width else { return self }
        let imageSize = CGSize(
            width: width,
            height: CGFloat(ceil(width/size.width * size.height))
        )
        return preparingThumbnail(of: imageSize)
    }
    
    func isImageLandscape(_ image: UIImage) -> Bool {
        return image.size.width > image.size.height
    }
    
    func get(_ name:String) -> UIImage {
        let systemImg: UIImage? = UIImage(systemName: name)
        let fileImg: UIImage? = UIImage(named: name)
        let defaultImg: UIImage? = UIImage(named: "NoPhotoText")

        if systemImg != nil {
            return systemImg!
        }else if fileImg != nil {
            return fileImg!
        }else if defaultImg != nil {
            return defaultImg!
        }else{
            return UIImage()
        }
    }
}


