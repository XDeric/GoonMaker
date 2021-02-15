//
//  Firebase.swift
//  GoonMaker
//
//  Created by EricM on 2/15/21.
//

import Foundation
import FirebaseFirestore

enum FireStoreCollections: String{
    case LeaderBoardInfo
}

enum SortingCriteria: String {
    case fromHighestToLowest = "score"
    var shouldSortDescending: Bool {
        switch self {
        case .fromHighestToLowest:
            return true
        }
    }
}

class FirestoreService {
    private init () {}
    
    static let manager = FirestoreService()
    private let db = Firestore.firestore()
    
    //create collection of name and score
    func createUserInfo(usrInfo: UserInfo, completion: @escaping (Result<(), Error>) -> ()) {
        let fields = usrInfo.fieldsDict
        db.collection(FireStoreCollections.LeaderBoardInfo.rawValue).addDocument(data: fields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    //get's userInfo collection
    func getLeaderBoard(sortingCriteria: SortingCriteria? = nil, completion: @escaping (Result<[UserInfo], Error>) -> ()) {
        let completionHandler: FIRQuerySnapshotBlock = {(snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let userInfos = snapshot?.documents.compactMap({ (snapshot) -> UserInfo? in
                    let userID = snapshot.documentID
                    let user = UserInfo(from: snapshot.data(), id: userID)
                    return user
                })
                completion(.success(userInfos ?? []))
            }
        }
        
        let collection = db.collection(FireStoreCollections.LeaderBoardInfo.rawValue)
       
        if let sortingCriteria = sortingCriteria {
            let query = collection.order(by:sortingCriteria.rawValue, descending: sortingCriteria.shouldSortDescending)
            query.getDocuments(completion: completionHandler)
        } else {
            collection.getDocuments(completion: completionHandler)
        }
    }
    
}
