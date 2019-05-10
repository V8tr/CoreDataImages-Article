//
//  ImageCache.swift
//  CoreDataImages-Article
//
//  Created by Vadym Bulavin on 4/25/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import UIKit

/// Saves and loads images to file on disk.
final class ImageStorage {
    
    let fileManager: FileManager
    let path: String
    
    init(name: String, fileManager: FileManager = FileManager.default) throws {
        self.fileManager = fileManager

        let url = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let path = url.appendingPathComponent(name, isDirectory: true).path
        self.path = path
        
        try createDirectory()
        try setDirectoryAttributes([.protectionKey: FileProtectionType.complete])
    }
    
    func createDirectory() throws {
        guard !fileManager.fileExists(atPath: path) else {
            return
        }
        
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    func setImage(_ image: UIImage, forKey key: String) throws {
        let data = try image.toData().unwrapOrThrow(Error.invalidImage)
        let filePath = makeFilePath(for: key)
        _ = fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
    }
    
    func removeObject(forKey key: String) throws {
        let filePath = makeFilePath(for: key)
        try fileManager.removeItem(atPath: filePath)
    }
    
    func image(forKey key: String) throws -> UIImage {
        let filePath = makeFilePath(for: key)
        let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
        let image = try UIImage(data: data).unwrapOrThrow(Error.invalidImage)
        return image
    }
}

// MARK: - File System Helpers

private extension ImageStorage {

    func setDirectoryAttributes(_ attributes: [FileAttributeKey: Any]) throws {
        try fileManager.setAttributes(attributes, ofItemAtPath: path)
    }
    
    func makeFileName(for key: String) -> String {
        let fileExtension = URL(fileURLWithPath: key).pathExtension
        return fileExtension.isEmpty ? key : "\(key).\(fileExtension)"
    }

    func makeFilePath(for key: String) -> String {
        return "\(path)/\(makeFileName(for: key))"
    }
}

// MARK: - Error

private extension ImageStorage {
    
    enum Error: Swift.Error {
        case invalidImage
    }
}
