//
//  JWVideoCapture.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/6/14.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class JWLiveVideoCapture: NSObject {
    
    var captureDevice: AVCaptureDevice?
    var maxFrameDuration: CMTime?//no defualt
    var minFrameDuration: CMTime?//no defualt
    var position: AVCaptureDevicePosition = .front
    
    override init() {
        super.init()
    }
    
    open class func `default`() -> JWLiveVideoCapture {
        let capture = JWLiveVideoCapture()
        capture.setupCapture()
        return capture
    }
    
    private func setupCapture()
    {
        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: self.position)
        self.captureDevice = captureDevice
    }
    
    open func setCaptureMaxFrameDuration(_ duration: CMTime) {
        do {
            try self.captureDevice?.lockForConfiguration()
        } catch let er as NSError {
            print(er.localizedFailureReason ?? "")
        }
        self.maxFrameDuration = duration
        self.captureDevice?.activeVideoMaxFrameDuration = duration
        self.captureDevice?.unlockForConfiguration()
    }
    
    open func setCaptureMinFrameDuration(_ duration: CMTime) {
        do {
            try self.captureDevice?.lockForConfiguration()
        } catch let er as NSError {
            print(er.localizedFailureReason ?? "")
        }
        self.minFrameDuration = duration
        self.captureDevice?.activeVideoMinFrameDuration = duration
        self.captureDevice?.unlockForConfiguration()
    }
    
    open func swichtDevicePosition(_ position: AVCaptureDevicePosition) {
        if self.position != position {
            self.position = position
            let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: position)
            self.captureDevice = captureDevice
            
            if self.maxFrameDuration != nil {
                self.captureDevice?.activeVideoMaxFrameDuration = self.maxFrameDuration!
            }
            
            if self.minFrameDuration != nil {
                self.captureDevice?.activeVideoMinFrameDuration = self.minFrameDuration!
            }
        }
    }
    
    

}
