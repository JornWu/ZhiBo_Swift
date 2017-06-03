//
//  LiveCaptureViewController.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/6/3.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import LFLiveKit

class LiveCaptureViewController:
    BaseViewController,
    LFLiveSessionDelegate
    
{
    private lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .medium2)
        let session = LFLiveSession(audioConfiguration: audioConfiguration,
                                    videoConfiguration: videoConfiguration)
        
        session?.delegate = self
        return session!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        self.setupTopControlView()
        self.session.preView = self.view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.requstAVAuthorization()
        self.startLive()
    }
    
    ///
    /// 注意一定要在plist文件中加入获取麦克风和摄像头权限的字段
    /// 开打此模块，程序会挂
    ///
    private func requstAVAuthorization() {
        let videoStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch videoStatus {
        ///
        /// 未认证
        ///
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (isAllow) in
                if isAllow {
                    //self.session.running = true
                }
            })
            
        ///
        /// 已经认证
        ///
        case .authorized:
            //self.session.running = true
            break
        ///
        /// 用户拒绝
        ///
        case .denied:
            self.session.running = false
            
        ///
        /// 用户拒绝
        ///
        case .restricted:
             self.session.running = false
        }
        
        
        let audioStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
        switch audioStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (isAllow) in
                ///
                /// asynchronous
                ///
                if isAllow {
                    self.session.running = true
                }
            })
        case .authorized:
            self.session.running = true
        case .denied:
            self.session.running = false
        case .restricted:
            self.session.running = false
        }
    }
    
    private func setupTopControlView() {
        
        let controlView = { () -> UIView in
            let view = UIView()
            view.backgroundColor = UIColor.clear
            self.view.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.top.left.width.equalToSuperview()
                make.height.equalTo(64)
            })
            
            return view
        }()
        
        /*let openBeautifulFaceBtn*/_ = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setImage(#imageLiteral(resourceName: "camra_beauty"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "camra_beauty_close"), for: .selected)
            controlView.addSubview(button)
            button.snp.makeConstraints({ (make) in
                make.left.top.equalTo(24)
                make.height.equalTo(40)
                make.width.equalTo(40)
            })
            
            button.reactive.controlEvents(.touchUpInside).observeValues {
                [unowned self]
                (btn) in
                btn.isSelected = !btn.isSelected
                
                self.session.beautyFace = !self.session.beautyFace
            }
            
            return button
        }()
        
        let closeBtn = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "talk_close_40x40"), for: .normal)
            controlView.addSubview(button)
            button.snp.makeConstraints({ (make) in
                make.top.equalTo(24)
                make.right.equalTo(-24)
                make.height.equalTo(40)
                make.width.equalTo(40)
            })
            
            button.reactive.controlEvents(.touchUpInside).observeValues {
                [unowned self]
                (btn) in
                self.stopLive()
                self.dismiss(animated: true, completion: nil)
            }
            
            return button
        }()
        
        /*let cameraChangeBtn*/_ = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "camera_change_40x40"), for: .normal)
            controlView.addSubview(button)
            button.snp.makeConstraints({ (make) in
                make.top.equalTo(24)
                make.right.equalTo(closeBtn.snp.left).offset(-24)
                make.height.equalTo(40)
                make.width.equalTo(40)
            })
            
            button.reactive.controlEvents(.touchUpInside).observeValues {
                [unowned self]
                (btn) in
                btn.isSelected = !btn.isSelected
                self.session.captureDevicePosition = btn.isSelected ? .back : .front
            }
            
            return button
        }()
    }
    
    func startLive() {
        let stream = LFLiveStreamInfo()
        stream.url = "rtmp://daniulive.com:1935/live/stream238";
        session.startLive(stream)
    }
    
    func stopLive() {
        session.running = false
        session.stopLive()
    }
    
    ///
    ///     LFLiveSessionDelegate
    ///
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo:", debugInfo ?? "nil")
    }
    
    ///
    ///     LFLiveSessionDelegate
    ///
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode:", errorCode)
    }
    
    ///
    ///     LFLiveSessionDelegate
    ///
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveStateDidChange:", state)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
