//
//  FCollectionReference.swift
//  iChat
//
//  Created by Imran Rahman on 10/05/18.
//  Copyright © 2018 Imran Rahman. All rights reserved.
//




import Foundation
import FirebaseFirestore
import Firebase

enum FCollectionReference: String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}


func reference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}

