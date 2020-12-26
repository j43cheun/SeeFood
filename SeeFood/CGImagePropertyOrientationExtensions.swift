//
//  CGImagePropertyOrientationExtensions.swift
//  SeeFood
//
//  Created by Justin Cheung on 12/24/20.
//

import SwiftUI

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError("Unexpected orientation: \(uiOrientation)")
        }
    }
}
