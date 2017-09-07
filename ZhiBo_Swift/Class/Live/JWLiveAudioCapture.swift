//
//  JWLiveAudioCapture.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/6/14.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class JWLiveAudioCapture: NSObject {
    
    var captureDevice: AVCaptureDevice?
    
    override init() {
        super.init()
    }
    
    open class func `default`() -> JWLiveAudioCapture {
        let capture = JWLiveAudioCapture()
        capture.setupCapture()
        return capture
    }
    
    private func setupCapture() {
        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInMicrophone, mediaType: AVMediaTypeAudio, position: .front)
        self.captureDevice = captureDevice
    }
}
