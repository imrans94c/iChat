//
//  OutgoingMessages.swift
//  iChat
//
//  Created by Imran Rahman on 10/31/18.
//  Copyright © 2018 Imran Rahman. All rights reserved.
//

import Foundation

class OutgoingMessage{
    
    let messageDictionary : NSMutableDictionary
    
    
    //MARK: Initializers
    
    
    //text message
    
    init(message:String, senderId: String, senderName: String, date: Date, status: String, type: String){
        
        messageDictionary = NSMutableDictionary(objects: [message, senderId, senderName,dateFormatter().string(from: date),status,type], forKeys: [kMESSAGE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying] )
    }
    
    
    //picture message
    
    init(message: String, pictureLink: String, senderId: String, senderName: String, date: Date, status: String, type: String){
        
        messageDictionary = NSMutableDictionary(objects: [message, pictureLink, senderId, senderName,dateFormatter().string(from: date), status, type], forKeys: [kMESSAGE as NSCopying, kPICTURE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
    }
    
    //audio message
    
    init(message: String, audio: String, senderId: String, senderName: String, date: Date, status: String, type: String){
        
        messageDictionary = NSMutableDictionary(objects: [message, audio, senderId, senderName,dateFormatter().string(from: date), status, type], forKeys: [kMESSAGE as NSCopying, kAUDIO as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
    }
    
    
    //video message
    
    init(message: String, video: String, thumbNail: NSData, senderId: String, senderName: String, date: Date, status: String, type: String){
        
        let picThumb = thumbNail.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0 ))
        
        messageDictionary = NSMutableDictionary(objects: [message, video, picThumb, senderId, senderName,dateFormatter().string(from: date), status, type], forKeys: [kMESSAGE as NSCopying, kVIDEO as NSCopying, kPICTURE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
    }
    
    
    //location message
    
    init(message: String, latitude: NSNumber, longitude: NSNumber, senderId: String, senderName: String, date: Date, status: String, type: String){
        
        messageDictionary = NSMutableDictionary(objects: [message, latitude, longitude, senderId, senderName,dateFormatter().string(from: date), status, type], forKeys: [kMESSAGE as NSCopying, kLATITUDE as NSCopying, kLONGITUDE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
    }
    
    
    //MARK: Send Message
    
    func sendMessage(chatRoomID: String, messageDictionary: NSMutableDictionary, memberIds: [String], membersToPush: [String]){
        
        let messageId = UUID().uuidString
        messageDictionary[kMESSAGEID] = messageId
        
        for memberId in memberIds {
            reference(.Message).document(memberId).collection(chatRoomID).document(messageId).setData(messageDictionary as! [String : Any])
        }
        
        updateRecents(chatRoomId: chatRoomID, lastMesssage: messageDictionary[kMESSAGE] as! String)
        
        //send push notifications
    }
    
    class func deleteMessage(withId: String, chatRoomId: String){
        reference(.Message).document(FUser.currentId())
            .collection(chatRoomId).document(withId).delete()
    }
    
    class func deleteMessage(withId: String, chatRoomId: String, memberIds: [String]) {
        for memberId in memberIds {
            reference(.Message).document(memberId)
                .collection(chatRoomId).document(withId).delete()
        }
    }
    
    class func updateMessage(withId: String, chatRoomId: String, memberIds: [String]){
        
        let readDate = dateFormatter().string(from: Date())
        
        let values = [kSTATUS : kREAD, kREADDATE : readDate]
        
        for userId in memberIds {
            reference(.Message).document(userId).collection(chatRoomId).document(withId).updateData(values)
        }
        
    }
}
