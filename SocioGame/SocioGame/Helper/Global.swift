//
//  Global.swift
//  SocioGame
//
//  Created by zein rezky chandra on 04/12/24.
//

import SwiftUI

// UIViewRepresentable to wrap the UIBlurEffect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // Update the UIVisualEffectView if needed
    }
}

// DateFormatter to format the current date and time
var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.timeZone = .gmt
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SS"
    return formatter
}

/// Convert image to base64String
///
/// - Parameter image: UIimage.
func imageToBase64(image: UIImage) -> String? {
    let resizedImage = resizeImage(image: image, targetWidth: image.size.width/2)
    guard let imageData = resizedImage?.jpegData(compressionQuality: 0.8) else { return nil }
    return imageData.base64EncodedString()
}

/// Convert base64String to image
///
/// - Parameter base64String: String base64
func base64ToImage(base64String: String) -> UIImage? {
    guard let imageData = Data(base64Encoded: base64String) else { return nil }
    return UIImage(data: imageData)
}

// Resize an image to a specific width (keeping aspect ratio)
func resizeImage(image: UIImage, targetWidth: CGFloat) -> UIImage? {
    let aspectRatio = image.size.height / image.size.width
    let targetHeight = targetWidth * aspectRatio
    let newSize = CGSize(width: targetWidth, height: targetHeight)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
    image.draw(in: CGRect(origin: .zero, size: newSize))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizedImage
}

extension Double {
    // Decrease pointing number into 1 digit
    var cleanValue: String {
        return String(format: "%.1f", self)
    }
}
