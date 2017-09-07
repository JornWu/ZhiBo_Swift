//
//  LiveViewController.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/2/27.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class LiveViewController: BaseViewController {
    
    private lazy var captureVC: LiveCaptureViewController = {
        return LiveCaptureViewController()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        self.setup()
    }
    
    private func setup() {
        
        /*let backgroundImageView*/_ = { /*() -> UIImageView in*/
            let imgView = UIImageView()
            imgView.image = #imageLiteral(resourceName: "bg_zbfx")
            self.view.addSubview(imgView)
            imgView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            })
            /*return imgView*/
        }/*这是一个尾随闭包*/()/*自己执行*/
        
        let tipsLabel = { () -> UILabel in
            let label = UILabel()
            label.text = "精彩的世界已经为您准备好了，您确定要开启直播吗？"
            label.font = UIFont.systemFont(ofSize: 20)
            label.numberOfLines = 0
            label.textColor = THEME_COLOR
            label.textAlignment = .center
            self.view.addSubview(label)
            label.snp.makeConstraints({ (make) in
                //make.top.equalTo(100 + 64)
                make.height.equalTo(100)
                make.width.equalTo(250)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-60)
            })
            
            return label
        }()
        
        /*let startLiveBtn*/_ = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.layer.cornerRadius = 5
            button.backgroundColor = THEME_COLOR
            button.setTitle("开始直播", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setImage(#imageLiteral(resourceName: "icon_beautifulface_19x19"), for: .normal)
            self.view.addSubview(button)
            button.snp.makeConstraints({ (make) in
                make.top.equalTo(tipsLabel.snp.bottom).offset(20)
                make.height.equalTo(40)
                make.width.equalTo(250)
                make.centerX.equalToSuperview()
            })
            
            button.reactive.controlEvents(.touchUpInside).observeValues {
                [unowned self]
                (btn) in
                
                //TODO: 使用JWLiveModule or LFLiveKit
                
                self.present(self.captureVC, animated: true, completion: nil)
                //self.present(JWLiveViewController(), animated: true, completion: nil)
            }
            
            return button
        }()
        
        _ = {
            let info = UILabel()
            info.text = "有问题欢迎和我交流:\n" +
            "微博: JornWu丶WwwwW \n" +
            "简书: JornWu丶WwwwW \n" +
            "QQ: 1249233155 \n" +
            "邮箱: jorn_wza@sina.com"
            info.textColor = THEME_COLOR
            info.numberOfLines = 0
            info.font = UIFont.systemFont(ofSize: 11)
            self.view.addSubview(info)
            info.snp.makeConstraints({ (make) in
                make.right.bottom.equalTo(-10)
                make.size.equalTo(CGSize(width: 135, height: 80))
            })
        }()
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
