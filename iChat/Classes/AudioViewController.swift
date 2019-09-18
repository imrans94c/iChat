//
//  AudioViewController.swift
//  iChat
//
//  Created by Imran Rahman on 11/6/18.
//  Copyright © 2018 Imran Rahman. All rights reserved.
//

import Foundation
import IQAudioRecorderController

class AudioViewController{
    
    var delegate : IQAudioRecorderViewControllerDelegate
    
    init(delegate_: IQAudioRecorderViewControllerDelegate) {
        delegate = delegate_
    }
    
    func presentAudioRecorder(target: UIViewController){
        
        let controller = IQAudioRecorderViewController()
        controller.delegate = delegate
        controller.title = "Record"
        controller.maximumRecordDuration = kAUDIOMAXDURATION
        controller.allowCropping = true
        
        target.presentBlurredAudioRecorderViewControllerAnimated(controller)
    }
    
}
