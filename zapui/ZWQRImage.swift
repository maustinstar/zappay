//
//  ZWQRImage.swift
//  zapui
//
//  Created by Michael Verges on 10/26/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import UIKit
import CoreImage

public class ZWQRImage {
    public static func from(_ string: String) -> UIImage? {
        guard let data = string.data(using: .utf8) else { return nil }
        print(string)
        if let image = CIFilter(name: "CIQRCodeGenerator", parameters: [
            "inputMessage": data
        ])?.outputImage {
            return UIImage(ciImage: image)
        }
        return nil
    }
}
