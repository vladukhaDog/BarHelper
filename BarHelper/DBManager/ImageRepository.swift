//
//  ImageRepository.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 21.10.2024.
//

import Foundation
import UIKit

extension ImageEntry {
    /// Returns UIImage from documents repository by this entry
    func getImage() -> UIImage?{
        guard let imageName = self.fileName,
              let imageURL = FileManager.default
                  .urls(for: .documentDirectory, in: .userDomainMask)
                  .first?
                  .appendingPathComponent(imageName),
              let imageData = try? Data(contentsOf: imageURL),
              let image = UIImage(data: imageData)
        else {return nil}
        return image
    }
}
