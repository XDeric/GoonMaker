//
//  UserInfo.swift
//  GoonMaker
//
//  Created by EricM on 2/15/21.
//

import Foundation
import FirebaseFirestore

struct UserInfo{
    let name: String
    let score: Int
    
    init(name: String, score: Int){
        self.name = name
        self.score = score
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let name = dict["name"] as? String,
              let score = dict["score"] as? Int else {return nil}
        
        self.name = name
        self.score = score
    }
    
    var fieldsDict: [String: Any] {
        return [
            "name": self.name,
            "score": self.score
        ]
    }
    
    
}
