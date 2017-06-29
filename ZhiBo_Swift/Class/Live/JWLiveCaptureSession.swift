//
//  JWLiveCaptureSession.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/6/14.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

enum JWSessionPreset {
    /** only provide three kinds */
    case high
    case medium
    case low
    
    fileprivate func sessionPresetString() -> String {
        switch self {
        case .high:
            return AVCaptureSessionPresetHigh
        case .low:
            return AVCaptureSessionPresetLow
        default:
            return AVCaptureSessionPresetMedium
        }
    }
}

class JWLiveCaptureSession:
NSObject,
AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureAudioDataOutputSampleBufferDelegate {
    /** videoCapture */
    var videoCapture: JWLiveVideoCapture? = nil {
        didSet {
            self.captureSession.beginConfiguration()
            
            /** videoInput */
            var videoInput: AVCaptureDeviceInput?
            do {
                videoInput = try AVCaptureDeviceInput.init(device: videoCapture?.captureDevice)
            } catch let er as NSError {
                print(er.localizedFailureReason ?? "")
            }
            
            if self.captureSession.canAddInput(videoInput) {
                self.captureSession.addInput(videoInput)
            }
            
            /** videoOutput */
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video queue"))
            
            let settings = NSDictionary(dictionaryLiteral: (String(describing: kCVPixelBufferPixelFormatTypeKey), kCVPixelFormatType_32BGRA))
            videoOutput.videoSettings = settings as! [AnyHashable : Any]
            
            //videoOutput.alwaysDiscardsLateVideoFrames = true
            
            if self.captureSession.canAddOutput(videoOutput) {
                self.captureSession.addOutput(videoOutput)
            }
            
            self.captureSession.commitConfiguration()
        }
    }
    
    /** audioCapture */
    var audioCapture: JWLiveAudioCapture? = nil {
        didSet {
            self.captureSession.beginConfiguration()
            
            /** audioInput */
            var audioInput: AVCaptureDeviceInput?
            do {
                audioInput = try AVCaptureDeviceInput.init(device: audioCapture?.captureDevice)
            } catch let er as NSError {
                print(er.localizedFailureReason ?? "")
            }
            
            if self.captureSession.canAddInput(audioInput) {
                self.captureSession.addInput(audioInput)
            }
            
            /** audioOutput */
            let audioOutput = AVCaptureAudioDataOutput()
            audioOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "audio queue"))
            
            if self.captureSession.canAddOutput(audioOutput) {
                self.captureSession.addOutput(audioOutput)
            }
            
            self.captureSession.commitConfiguration()
        }
    }
    
    /** previewLayer */
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var videoConnection: AVCaptureConnection?
    
    
    /** sessionPreset */
    var sessionPreset: JWSessionPreset? = .medium {
        didSet {
            self.captureSession.beginConfiguration()
            
            if self.captureSession.canSetSessionPreset(sessionPreset?.sessionPresetString()) {
                self.captureSession.sessionPreset = sessionPreset?.sessionPresetString()
            }
            
            self.captureSession.commitConfiguration()
        }
    }
    
    /** captureSession */
    private lazy var captureSession: AVCaptureSession = {
        return AVCaptureSession()
    }()
    
    override init() {
        super.init()
        setSession()
        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVCaptureDeviceWasConnected).observeValues { (noti) in
            //
            print("Device was connected")
        }
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVCaptureDeviceWasDisconnected).observeValues { (noti) in
            //
            print("Device was disconnected")
        }
    }
    
    convenience init(videoCapture: JWLiveVideoCapture, audioCapture: JWLiveAudioCapture) {
        self.init()
        self.videoCapture = videoCapture
        self.audioCapture = audioCapture
    }
    
    open class func `default`() -> JWLiveCaptureSession {
        let __self = JWLiveCaptureSession()
        
        /** video capture */
        __self.videoCapture = JWLiveVideoCapture.default()
        
        /** audio capture */
        __self.audioCapture = JWLiveAudioCapture.default()
        
        return __self
    }
    
    public func start() {
        self.captureSession.startRunning()
    }
    
    public func stop() {
        self.captureSession.stopRunning()
    }
    
    private func setSession() {
        /** 适用于wi-fi */
        if self.captureSession.canSetSessionPreset(AVCaptureSessionPresetMedium) {
            self.captureSession.sessionPreset = AVCaptureSessionPresetMedium
        }
        
        self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
        
        /** preview */
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        //previewLayer?.frame = (UIApplication.shared.delegate?.window??.bounds)!
        self.previewLayer = previewLayer
    }
    
//MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        //FIXME: video
        /** video connection */
        if captureOutput is AVCaptureVideoDataOutput {
            
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
            
            ///
            ///    let image = imageFromSampleBuffer(sampleBuffer)
            ///     //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
            ///         contextInfo:(void *)contextInfo;
            ///     UIImageWriteToSavedPhotosAlbum(image!, self,
            ///     #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            ///
            
            
        }
        
        //FIXME: audio
        /** audio connection */
        if captureOutput is AVCaptureAudioDataOutput {
            
        }
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        guard error != nil else {
            print("图片保存成功！")
            return
        }
        print("图片保存失败！Error:", error?.localizedDescription ?? "")
        
    }
    
//    var index = 0
    
    private func imageFromSampleBuffer(_ buffer: CMSampleBuffer) -> UIImage? {
        /** Get a CMSampleBuffer's Core Video image buffer for the media data */
        let imageBuffer: CVImageBuffer? = CMSampleBufferGetImageBuffer(buffer)
        
        /** Lock the base address of the pixel buffer */
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        /** Get the number of bytes per row for the plane pixel buffer */
        let baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer!, 0)

        /** // Get the number of bytes per row for the plane pixel buffer */
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer!, 0)
        
        /** Get the pixel buffer width and height */
        let width = CVPixelBufferGetWidth(imageBuffer!)
        let height = CVPixelBufferGetHeight(imageBuffer!)
        
        /** Create a device-dependent gray color space */
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        /** Create a bitmap graphics context with the sample buffer data */
        let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo:UInt32(CGImageByteOrderInfo.order32Little.hashValue | CGImageAlphaInfo.first.hashValue))

        /** Create a Quartz image from the pixel data in the bitmap graphics context */
        let quartzImage = context!.makeImage()
        
//        let length = bytesPerRow * width * height
//        let mBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
//        let data = NSData(bytesNoCopy: baseAddress!, length: length, freeWhenDone: false)
//        let data = Data(bytesNoCopy: baseAddress!, count: length, deallocator: .free)
//        let image = UIImage(data: data, scale: 1.0)
//        
//        index += 1
//        do {
//            try data.write(to: URL(string: "~/Users/jornwu/Desktop/myShaoNv_" + "\(index)" + ".png")!, options: .withoutOverwriting)
//        } catch let er as NSError {
//            print(er.localizedFailureReason ?? "")
//        }
//        print(data)
        
        /** Unlock the pixel buffer */
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        /** Free up the context and color space */
        /** (don't neend, core foundation objects are automaticall memory managed) */
        ///GContextRelease(context)
        ///CGColorSpaceRelease(colorSpace)
        
        /** Create an image object from the Quartz image */
        let image = UIImage(cgImage: quartzImage!, scale: 1, orientation: .up)
        
        /** Release the Quartz image */
        /** (don't neend, core foundation objects are automaticall memory managed) */
        ///CGImageRelease(quartzImage!)
        
        return image
    }
    
    public func swichDevicePosition() {
        for input in self.captureSession.inputs {
            let videoInput = input as? AVCaptureDeviceInput
            if videoInput?.device == self.videoCapture?.captureDevice {
                var position = self.videoCapture?.position
                position = (position == .front) ? .back : .front
                
                self.captureSession.beginConfiguration()
                
                self.videoCapture?.swichtDevicePosition(position!)
                self.captureSession.removeInput(videoInput)
                var input: AVCaptureDeviceInput?
                do {
                    input = try AVCaptureDeviceInput.init(device: videoCapture?.captureDevice)
                } catch let er as NSError {
                    print(er.localizedFailureReason ?? "")
                }
                if self.captureSession.canAddInput(input) {
                    self.captureSession.addInput(input)
                }
                
                self.captureSession.commitConfiguration()
            }
        }
    }
}
