//
//  IncomingMessages.swift
//  iChat
//
//  Created by Imran Rahman on 11/2/18.
//  Copyright © 2018 Imran Rahman. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class IncomingMessage{
    
    var collectionView: JSQMessagesCollectionView
    
    init(collectionView_: JSQMessagesCollectionView) {
        collectionView = collectionView_
    }
    
    
    //MARK: CreateMessage
    
    func createMessage(messageDictionary : NSDictionary, chatRoomId : String) -> JSQMessage? {
        
        var message: JSQMessage?
        
        let type = messageDictionary[kTYPE] as! String
        
        switch type {
        case kTEXT:
            message = createTextMeaasge(messageDictionary: messageDictionary, chatRoomId: chatRoomId)
        case kPICTURE:
            message = createPictureMeaasge(messageDictionary: messageDictionary)
        case kVIDEO:
            message = createVideoMeaasge(messageDictionary: messageDictionary)
        case kAUDIO:
            message = createAudioMeaasge(messageDictionary: messageDictionary)
        case kLOCATION:
             message = createLocationMeaasge(messageDictionary: messageDictionary)
            
        default:
             print("Unknown message type")
        }
        
        if message != nil{
            return message
        }
        return nil
    }
    
    //MARK: Create Message
    
    func createTextMeaasge(messageDictionary: NSDictionary, chatRoomId: String) -> JSQMessage {
        
        let name = messageDictionary[kSENDERNAME] as? String
        let userId = messageDictionary[kSENDERID] as? String

        var date : Date!
        
        if let created = messageDictionary[kDATE]{
            if(created as! String).count != 14 {
                date = Date()
            }else{
                date = dateFormatter().date(from: created as! String)
            }
        }else{
            date = Date()
        }
        
        let text = messageDictionary[kMESSAGE] as! String
        
        return JSQMessage(senderId: userId, senderDisplayName: name, date: date, text: text)
        
    }
    
     func createPictureMeaasge(messageDictionary: NSDictionary) -> JSQMessage {
        
        let name = messageDictionary[kSENDERNAME] as? String
        let userId = messageDictionary[kSENDERID] as? String
        
        var date : Date!
        
        if let created = messageDictionary[kDATE]{
            if(created as! String).count != 14 {
                date = Date()
            }else{
                date = dateFormatter().date(from: created as! String)
            }
        }else{
            date = Date()
        }
        let mediaItem = PhotoMediaItem(image: nil)
        mediaItem?.appliesMediaViewMaskAsOutgoing = returnOutgoingStatusForUser(senderId: userId!)

        // download Image
        
            downloadImage(imageUrl: messageDictionary[kPICTURE] as! String) { (image) in
                
                if image != nil {
                  mediaItem?.image = image!
                    self.collectionView.reloadData()
                }
        }
        
        return JSQMessage(senderId: userId, senderDisplayName: name, date: date, media: mediaItem)
    }
    
    
    func createVideoMeaasge(messageDictionary: NSDictionary) -> JSQMessage {
        
        let name = messageDictionary[kSENDERNAME] as? String
        let userId = messageDictionary[kSENDERID] as? String
        
        var date : Date!
        
        if let created = messageDictionary[kDATE]{
            if(created as! String).count != 14 {
                date = Date()
            }else{
                date = dateFormatter().date(from: created as! String)
            }
        }else{
            date = Date()
        }
        
        let videoURL = NSURL(fileURLWithPath: messageDictionary[kVIDEO] as! String)
        
        let mediaItem = VideoMessage(withFileURL: videoURL, maskOutgoin: returnOutgoingStatusForUser(senderId: userId!))
    
        // download video
        
        downloadVideo(videoUrl: messageDictionary[kVIDEO] as! String){ (isReadyToPlay, fileName) in
            
            let url = NSURL(fileURLWithPath: fileInDocumentsDictionary(fileName: fileName))
            
            mediaItem.status = kSUCCESS
            mediaItem.fileURL = url
            
            imageFromData(pictureData: messageDictionary[kPICTURE] as! String, withBlock: { (image) in
                
                if image != nil {
                    mediaItem.image = image!
                    self.collectionView.reloadData()
                }
            })
            self.collectionView.reloadData()
            
        }
        return JSQMessage(senderId: userId, senderDisplayName: name, date: date, media: mediaItem)
    }

    
    
    
    func createAudioMeaasge(messageDictionary: NSDictionary) -> JSQMessage {
        
        let name = messageDictionary[kSENDERNAME] as? String
        let userId = messageDictionary[kSENDERID] as? String
        
        var date : Date!
        
        if let created = messageDictionary[kDATE]{
            if(created as! String).count != 14 {
                date = Date()
            }else{
                date = dateFormatter().date(from: created as! String)
            }
        }else{
            date = Date()
        }
        
        
        let audioItem = JSQAudioMediaItem(data: nil)
        
        audioItem.appliesMediaViewMaskAsOutgoing = returnOutgoingStatusForUser(senderId: userId!)
        
        let audioMessage = JSQMessage(senderId: userId!, displayName: name!, media: audioItem)
        
        
        
        // download audio
        
        downloadAudio(audioUrl: messageDictionary[kAUDIO] as! String) { (fileName) in
            
            let url = NSURL(fileURLWithPath: fileInDocumentsDictionary(fileName: fileName!))
            
            let audioData = try? Data(contentsOf: url as URL)
            audioItem.audioData = audioData
            self.collectionView.reloadData()
        }
        
       
        return audioMessage!
    }

    
    //MARK: Create Location
    
    func createLocationMeaasge(messageDictionary: NSDictionary) -> JSQMessage {
        
        let name = messageDictionary[kSENDERNAME] as? String
        let userId = messageDictionary[kSENDERID] as? String
        
        var date : Date!
        
        if let created = messageDictionary[kDATE]{
            if(created as! String).count != 14 {
                date = Date()
            }else{
                date = dateFormatter().date(from: created as! String)
            }
        }else{
            date = Date()
        }
        
       
        let latitude = messageDictionary[kLATITUDE] as? Double
        let longitude = messageDictionary[kLONGITUDE] as? Double
        
        let mediaItem = JSQLocationMediaItem(location: nil)
        
        mediaItem?.appliesMediaViewMaskAsOutgoing = returnOutgoingStatusForUser(senderId: userId!)
        
        let location = CLLocation(latitude: latitude!, longitude: longitude!)
        
        mediaItem?.setLocation(location, withCompletionHandler:{ self.collectionView.reloadData()
            
        })
        
        return JSQMessage(senderId: userId, senderDisplayName: name, date: date, media: mediaItem)
        
    }
    
    
    
    //MARK: Helper
    
    func returnOutgoingStatusForUser(senderId : String) -> Bool {
        return senderId == FUser.currentId()
    }
    
}
