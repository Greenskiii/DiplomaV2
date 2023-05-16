//
//  FirestoreManager.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 23.03.2023.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

enum FirebaseCollection: String {
    case user = "users"
    case house = "houses"
    case room = "rooms"
}

enum FirestoreManagerError: Error {
    case error
    case initError
}

final class FirestoreManager {
    private let db = Firestore.firestore()
    
    func get<T: FirestoreModel>(docId: String,
                                collection: FirebaseCollection,
                                responseType: T.Type = T.self,
                                completion:  @escaping (Result<T, FirestoreManagerError>) -> Void) {
        let document = db.collection(collection.rawValue).document(docId)
        
        document.getDocument { (document, error) in
            if let document = document {
                if let value = T(id: document.documentID, snapshot: document) {
                    completion(.success(value))
                } else {
                    completion(.failure(.initError))
                }
            } else {
                completion(.failure(.error))
            }
        }
    }
    
    func add(data: [String: Any],
             documentId: String,
             collection: FirebaseCollection,
             completion:  @escaping (Result<Any, FirestoreManagerError>) -> Void) {
        let document = db.collection(collection.rawValue).document(documentId)
        
        document.setData(data) { error in
            if let error = error {
                completion(.failure(.error))
                print("Error writing document: \(error)")
            } else {
                completion(.success("Success"))
                print("Document successfully written!")
            }
        }
    }
    
    func update(data: [String: Any],
                documentId: String,
                collection: FirebaseCollection,
                completion:  @escaping (Result<Any, FirestoreManagerError>) -> Void) {
        let document = db.collection(collection.rawValue).document(documentId)
        
        document.updateData(data) { error in
            if let error = error {
                completion(.failure(.error))
                print("Error writing document: \(error)")
            } else {
                completion(.success("Success"))
                print("Document successfully written!")
            }
        }
    }
    
    func delete(documentId: String,
                collection: FirebaseCollection,
                completion:  @escaping (Result<Any, FirestoreManagerError>) -> Void) {
        let document = db.collection(collection.rawValue).document(documentId)
        
        document.delete() { error in
            if let error = error {
                completion(.failure(.error))
                print("Error writing document: \(error)")
            } else {
                completion(.success("Success"))
                print("Document successfully written!")
            }
        }
    }
}
