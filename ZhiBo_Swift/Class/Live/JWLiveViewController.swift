//
//  JWLivePreView.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/6/14.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class JWLiveViewController: BaseViewController {
    
    lazy var captureSession: JWLiveCaptureSession = {
        return JWLiveCaptureSession.default()
    }()
    
    override func viewDidLoad() {
        startCapture()
        setupControls()
    }
    
    private func startCapture() {
        self.captureSession.previewLayer?.frame = CGRect(x: 0, y: -70, width: 500, height: 800)
        self.view.layer.addSublayer(self.captureSession.previewLayer!)
        //self.captureSession.start()
    }
    
    private func setupControls() {
        let /*switchCamera*/ _ = { () -> UIButton in
            let btn = UIButton(type: .custom)
            self.view.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.top.equalTo(30)
                make.size.equalTo(CGSize(width: 40, height: 40))
            })
            
            btn.setImage(#imageLiteral(resourceName: "camera_change_40x40"), for: .normal)
            btn.reactive.controlEvents(.touchUpInside).observeValues({
                [unowned self]
                (btn) in
                self.captureSession.swichDevicePosition()
            })
            return btn
        }()
        
        let /*closeCamera*/ _ = { () -> UIButton in
            let btn = UIButton(type: .custom)
            self.view.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.top.equalTo(30)
                make.right.equalTo(-30)
                make.size.equalTo(CGSize(width: 40, height: 40))
            })
            
            btn.setImage(#imageLiteral(resourceName: "talk_close_40x40"), for: .normal)
            btn.reactive.controlEvents(.touchUpInside).observeValues({
                [unowned self]
                (btn) in
                self.dismiss(animated: true, completion: { 
                    print("你已经退出直播。")
                })
            })
            return btn
        }()
        
        let /*startOrStop*/ _ = { () -> UIButton in
            let btn = UIButton(type: .custom)
            self.view.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.bottom.equalTo(-30)
                make.size.equalTo(CGSize(width: 70, height: 70))
                make.centerX.equalToSuperview()
            })
            
            btn.alpha = 0.6
            btn.layer.cornerRadius = 35
            btn.layer.borderWidth = 1
            btn.layer.borderColor = NORMAL_TEXT_COLOR.cgColor
            btn.layer.backgroundColor = THEME_COLOR.cgColor
            btn.setTitleColor(NORMAL_TEXT_COLOR, for: .normal)
            
            btn.setTitle("Start", for: .normal)
            btn.reactive.controlEvents(.touchUpInside).observeValues({
                [unowned self]
                (btn) in
                btn.isSelected = !btn.isSelected
                
                ///
                /// 这里应该控制是否发送数据到服务器
                ///
                
                if btn.isSelected {
                    btn.setTitle("Stop", for: .normal)
                    btn.layer.borderColor = THEME_COLOR.cgColor
                    btn.layer.backgroundColor = UIColor.white.cgColor
                    btn.setTitleColor(THEME_COLOR, for: .normal)
                    self.captureSession.start()
                }
                else {
                    btn.setTitle("Start", for: .normal)
                    btn.layer.borderColor = NORMAL_TEXT_COLOR.cgColor
                    btn.layer.backgroundColor = THEME_COLOR.cgColor
                    btn.setTitleColor(NORMAL_TEXT_COLOR, for: .normal)
                    self.captureSession.stop()
                }
            })
            
            return btn
        }()
    }

}
