//
//  KeychainManager.swift
//  TDD
//
//  Created by 최안용 on 7/30/24.
//

import Foundation
import Security

enum KeychainError: Error {
    case notFound
    case undexpectedData
    case unHandleError(status: OSStatus)
}

enum SaveType: String {
    case access = "accessToken"
    case refresh = "refreshToken"
    case userIdentifier = "userID"
    case clientToken = "clientToken"
    
}

final class KeychainManager {
    static let shared = KeychainManager()
    
    func create(_ type: SaveType, input: String) throws {
        let data = input.data(using: .utf8)!
        
        let createQuery: [CFString: Any]
        
        switch type {
        case .access, .refresh:
            createQuery = [
                kSecClass: kSecClassKey,
                kSecAttrType: type.rawValue,
                kSecValueData: data
            ]

        case .userIdentifier, .clientToken:
            createQuery = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: type.rawValue,
                kSecValueData: data
            ]
        }
        
        let status = SecItemAdd(createQuery as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("\(type.rawValue) 키체인 생성 성공")
        } else if status == errSecDuplicateItem {
            print("\(type.rawValue) 키체인 업데이트")
            try update(type, value: data)
        } else {
            print("\(type.rawValue) 키체인 생성 실패")
            throw KeychainError.unHandleError(status: status)
        }
    }
    
    func getData(_ type: SaveType) throws -> String {
        let searchQuery: [CFString: Any]
        
        switch type {
        case .access, .refresh:
            searchQuery = [
                kSecClass: kSecClassKey,
                kSecAttrType: type.rawValue,
                kSecReturnAttributes: true,
                kSecReturnData: true
            ]
        case .userIdentifier, .clientToken:
            searchQuery = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: type.rawValue,
                kSecReturnAttributes: true,
                kSecReturnData: true
            ]
        }
        
        var result: CFTypeRef?
        
        let status = SecItemCopyMatching(searchQuery as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                print("\(type.rawValue) 키체인 항목을 찾을 수 없음")
                throw KeychainError.notFound
            } else {
                print("\(type.rawValue) 키체인 검색 실패")
                throw KeychainError.unHandleError(status: status)
            }
        }
        
        guard let existingItem = result as? [String: Any],
              let data = existingItem[kSecValueData as String] as? Data,
              let output = String(data: data, encoding: .utf8) else {
            print("예상치 못한 데이터 반환")
            throw KeychainError.undexpectedData
        }
        
        return output
    }
    
    private func update(_ type: SaveType, value: Data) throws {
        let originalQuery: [CFString: Any]
        
        switch type {
        case .access, .refresh:
            originalQuery = [
                kSecClass: kSecClassKey,
                kSecAttrType: type.rawValue
            ]
        case .userIdentifier, .clientToken:
            originalQuery = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: type.rawValue
            ]
        }
        
        let updateQuery: [CFString: Any] = [
            kSecValueData: value
        ]
        
        let status = SecItemUpdate(originalQuery as CFDictionary, updateQuery as CFDictionary)
        
        if status == errSecSuccess {
            print("\(type.rawValue) 키체인 업데이트 성공")
        } else {
            print("\(type.rawValue) 키체인 업데이트 실패")
            throw KeychainError.unHandleError(status: status)
        }
    }
    
    func delete(_ type: SaveType) throws {
        let deleteQuery: [CFString: Any]
        
        switch type {
        case .access, .refresh:
            deleteQuery = [
                kSecClass: kSecClassKey,
                kSecAttrType: type.rawValue
            ]
        case .userIdentifier, .clientToken:
            deleteQuery = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: type.rawValue  
            ]
        }
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("keychainError.unhandledError")
            throw KeychainError.unHandleError(status: status)
        }
        print("\(type.rawValue) 키체인 삭제 성공")
    }
}
