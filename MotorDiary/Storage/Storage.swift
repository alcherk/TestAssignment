//
//  Storage.swift
//  MotorDiary
//
//  Created by lex on 10/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import Foundation

protocol StorageProtocol {
    init(fileName: String)
    func save<T: Encodable>(_ object: T)
    func load<T: Decodable>(as type: T.Type) -> T?
    func exists() -> Bool
    func clean()
}

class Storage: StorageProtocol {
    private let fileName: String
    
    required init(fileName: String) {
        self.fileName = fileName
    }
    
    func save<T: Encodable>(_ object: T) {
        guard let url = documentsUrl?.appendingPathComponent(fileName, isDirectory: false) else { return }
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            clean()
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load<T: Decodable>(as type: T.Type) -> T? {
        guard let url = documentsUrl?.appendingPathComponent(fileName, isDirectory: false) else {
            return nil
        }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            print("File at path \(url.path) does not exist!")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("No data at \(url.path)!")
        }
        
        return nil
    }
    
    func exists() -> Bool {
        guard let url = documentsUrl?.appendingPathComponent(fileName, isDirectory: false) else { return false }
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    func clean() {
        guard let url = documentsUrl?.appendingPathComponent(fileName, isDirectory: false) else { return }

        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension Storage {
    fileprivate var documentsUrl: URL? {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print("storage: \(url.absoluteString)")
            return url
        } else {
            print("Could not create URL for specified directory!")
        }
        
        return nil
    }
}
