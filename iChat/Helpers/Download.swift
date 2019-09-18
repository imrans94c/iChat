//
//  Download.swift
//  iChat
//
//  Created by Imran Rahman on 11/5/18.
//  Copyright © 2018 Imran Rahman. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase
import MBProgressHUD
import AVFoundation

let storage  = Storage.storage()


//image

func uploadImage(image: UIImage, chatRoomId: String, view: UIView, completion: @escaping(_ imageLink: String?)  -> Void){
    
    let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
    
    progressHUD.mode  = .determinateHorizontalBar
    
    let dateString = dateFormatter().string(from: Date())
    
    let photoFileName = "PictureMessages/" + FUser.currentId() + "/" + chatRoomId + "/" + dateString + ".jpg"
    
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(photoFileName)
    
    let imageData = image.jpegData(compressionQuality: 0.7)
    
    var task : StorageUploadTask!
    
    task = storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
        
        task.removeAllObservers()
        
        progressHUD.hide(animated: true)
        
        if error != nil {
            print("error uploading image \(error!.localizedDescription)")
            return
        }
        
        storageRef.downloadURL(completion: { (url, error) in
            guard let downloadUrl = url else{
                
                completion(nil)
                return
            }
            
            completion(downloadUrl.absoluteString)
        })
        
    })
    
    task.observe(StorageTaskStatus.progress) { (snapshot) in
        progressHUD.progress = Float((snapshot.progress?.completedUnitCount)!) /
        Float((snapshot.progress?.totalUnitCount)!)
    }
}


    
func downloadImage(imageUrl: String, completion: @escaping(_ image: UIImage?) -> Void){
        
    let imageURL = NSURL(string: imageUrl)
    
    let imageFileName = (imageUrl.components(separatedBy: "%").last!).components(separatedBy:"?").first!
    
    if fileExistsAtPath(path: imageFileName){
        //exist
        
        if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDictionary(fileName: imageFileName)){
            completion(contentsOfFile)
        }else{
            print("could not generate image")
            completion(nil)
        }
    }else{
         //does not exist
        
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        
        downloadQueue.async {
            let data = NSData(contentsOf: imageURL! as URL)
            
            if data != nil {
                var docURL = getDocumentsURL()
                
                docURL = docURL.appendingPathComponent(imageFileName, isDirectory: false)
                
                data!.write(to: docURL, atomically: true)
                
                let imageToReturn = UIImage(data: data! as Data)
                DispatchQueue.main.async {
                    completion(imageToReturn!)
                }
            }else{
                DispatchQueue.main.async {
                    print("No image in database")
                    completion(nil)
                }
            }
        }
    }
    
    }

//Video

func uploadVideo(video: NSData, chatRoomId: String, view: UIView, completion: @escaping(_ videoLink: String?)  -> Void){
    
    let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
    
    progressHUD.mode  = .determinateHorizontalBar
    
    let dateString = dateFormatter().string(from: Date())
    
    let videoFileName = "VideoMessages/" + FUser.currentId() + "/" + chatRoomId + "/" + dateString + ".mov"
    
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(videoFileName)
    
    var task : StorageUploadTask!
    
    task = storageRef.putData(video as Data, metadata: nil, completion: { (metadata, error) in
        
        task.removeAllObservers()
        
        progressHUD.hide(animated: true)
        
        if error != nil {
            print("error uploading video \(error!.localizedDescription)")
            return
        }
        storageRef.downloadURL(completion: { (url, error) in
            
            guard let downloadUrl = url else {
                completion(nil)
                return
            }
            completion(downloadUrl.absoluteString)
        })

    })
    
    task.observe(StorageTaskStatus.progress) { (snapshot) in
        
        progressHUD.progress = Float((snapshot.progress?.completedUnitCount)!) /
            Float((snapshot.progress?.totalUnitCount)!)
    }
    
}



func downloadVideo(videoUrl: String, completion: @escaping(_ isReadyToPlay: Bool, _ videoFileName: String) -> Void){
    
    let videoURL = NSURL(string: videoUrl)
   
    
    let videoFileName = (videoUrl.components(separatedBy: "%").last!).components(separatedBy:"?").first!
 
    
    if fileExistsAtPath(path: videoFileName){
        //exist
            completion(true, videoFileName )
    }else{
        //does not exist
        
        let downloadQueue = DispatchQueue(label: "videoDownloadQueue")
        
        downloadQueue.async {
            let data = NSData(contentsOf: videoURL! as URL)
            
            if data != nil {
                var docURL = getDocumentsURL()
                
                docURL = docURL.appendingPathComponent(videoFileName, isDirectory: false)
                
                data!.write(to: docURL, atomically: true)
                
                DispatchQueue.main.async {
                    completion(true, videoFileName)
                }
            }else{
                DispatchQueue.main.async {
                    print("No video in database")
                }
            }
        }
    }
    
}



//Audio messages

func uploadAudio(audioPath: String, chatRoomId: String, view: UIView, completion: @escaping(_ audioLink: String?)  -> Void){
    
    let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
    
    progressHUD.mode  = .determinateHorizontalBar
    
    let dateString = dateFormatter().string(from: Date())
    
    let audioFileName = "audioMessages/" + FUser.currentId() + "/" + chatRoomId + "/" + dateString + ".m4a"
    
    let audio = NSData(contentsOfFile: audioPath)
    
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(audioFileName)
    
    var task : StorageUploadTask!
    
    task = storageRef.putData(audio! as Data, metadata: nil, completion: { (metadata, error) in
        
        task.removeAllObservers()
        
        progressHUD.hide(animated: true)
        
        if error != nil {
            print("error uploading audio \(error!.localizedDescription)")
            return
        }
        storageRef.downloadURL(completion: { (url, error) in
            
            guard let downloadUrl = url else {
                completion(nil)
                return
            }
            completion(downloadUrl.absoluteString)
        })
        
    })
    
    task.observe(StorageTaskStatus.progress) { (snapshot) in
        
        progressHUD.progress = Float((snapshot.progress?.completedUnitCount)!) /
            Float((snapshot.progress?.totalUnitCount)!)
    }
    
}



func downloadAudio(audioUrl: String, completion: @escaping(_ audioFileName: String?) -> Void){
    
    let audioURL = NSURL(string: audioUrl)
    
    let audioFileName = (audioUrl.components(separatedBy: "%").last!).components(separatedBy:"?").first!
    
    if fileExistsAtPath(path:audioFileName){
        //exist
        completion(audioFileName)
        
    }else{
        //does not exist
        
        let downloadQueue = DispatchQueue(label: "audioDownloadQueue")
        
        downloadQueue.async {
            let data = NSData(contentsOf: audioURL! as URL)
            
            if data != nil {
                var docURL = getDocumentsURL()
                
                docURL = docURL.appendingPathComponent(audioFileName, isDirectory: false)
                
                data!.write(to: docURL, atomically: true)
                
                DispatchQueue.main.async {
                    completion(audioFileName)
                }
            }else{
                DispatchQueue.main.async {
                    print("No audio in database")
                }
            }
        }
    }
    
}




//Helpers

func videoThumbnail(video: NSURL) -> UIImage{
    
    let asset = AVURLAsset(url: video as URL, options: nil)
    
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    
    imageGenerator.appliesPreferredTrackTransform = true
    
    let time = CMTime(seconds: 0.5, preferredTimescale: 1000)
    
    var actualTime = CMTime.zero
    
    var image : CGImage?
    
    do {
        image = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
    }
    catch let error as NSError{
        print(error.localizedDescription)
    }
    let thumbnail = UIImage(cgImage: image!)
    
    return thumbnail
}







    
func fileInDocumentsDictionary(fileName: String) -> String{
        
        let fileURL = getDocumentsURL().appendingPathComponent(fileName)
        
        return fileURL.path
    }
    
func getDocumentsURL() -> URL{
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        return documentURL!
    }
    
func  fileExistsAtPath(path: String)  -> Bool{
        
        var doesExist = false
        let filePath = fileInDocumentsDictionary(fileName: path)
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filePath){
            doesExist = true
        }else{
            doesExist = false
        }
        
        return doesExist
    }
    

