//
//  ImageRepository.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 21.10.2024.
//

import Foundation
import UIKit
import CoreData

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

/// Dependency Injection info for a class that writes/gets Images and notifies about it
typealias ImagesDI = Repository<ImageEntry> & ImagesRepositoryProtocol

protocol ImagesRepositoryProtocol {
    func createImage(image: UIImage) async throws -> ImageEntry
}

final class ImagesRepository: ImagesDI {
    func createImage(image: UIImage) async throws -> ImageEntry {
        try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.context.performAndWait {
                    // get the documents directory url
                    guard let documentsDirectory = FileManager.default
                        .urls(for: .documentDirectory, in: .userDomainMask)
                        .first
                    else {
                        continuation.resume(throwing: RepositoryError.failedToFindSaveRepository)
                        return
                    }
                    // choose a name for your image
                    let fileName = "\(UUID().uuidString).jpg"
                    // create the destination file url to save your image
                    let fileURL = documentsDirectory.appendingPathComponent(fileName)
                    // get your UIImage jpeg data representation and check if the destination file url already exist
                    guard let data = image.pngData() else {
                        continuation.resume(throwing: RepositoryError.failedToGeneratePNG)
                        return
                    }
                        // writes the image data to disk
                        try data.write(to: fileURL)
                        let imageEntry = ImageEntry(context: self.context)
                        imageEntry.fileName = fileName
                        if self.context.hasChanges{
                            try context.save()
                        }
                    self.sendAction(.added(imageEntry))
                    continuation.resume(returning: imageEntry)
                }
            } catch {
                continuation.resume(throwing: RepositoryError.contextError(error))
            }
        })
    }
}
