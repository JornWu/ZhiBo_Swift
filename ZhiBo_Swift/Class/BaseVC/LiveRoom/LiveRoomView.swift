//
//  LiveRoomView.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/4/26.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

private let instance = LiveRoomView()
class LiveRoomView: UIView, PLPlayerDelegate {

///---------------------------------------------------
/// Singleton
///
    
    final class var shareLiveRoomView: LiveRoomView {
        
//        ///
//        ///     添加用户交互图层
//        ///
//        intance.addSubview(intance.interactiveView)
//        intance.interactiveView.snp.makeConstraints { (make) in
//            make.edges.height.equalToSuperview()
//        }
        
        ///
        ///     监听直播间的切换
        ///
        instance.currentLiveModeSignal.observeValues {
            (model) in
//            [weak instance]
//            (model) in
//            if instance != nil {
//                instance!.snp.makeConstraints({ (make) in
//                    if let supView = instance!.superview {
//                        make.height.width.equalTo(supView)
//                    }
//                })
//                print("------instance:", instance!)
//                instance!.setupLivePlayer(withRoomModel: model)
//            }
            instance.setupLivePlayer(withRoomModel: model)
        }
        
        return instance;
    }
    
    ///
    ///     私有化构造方法，避免外部调用
    ///
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    ///
    ///     私有化构造方法，避免外部调用
    ///
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
///--------------------------property-------------------------
    
    private lazy var currentLiveModeSignal: Signal<LiveRoomModel, NoError> = {
        
        ///
        ///     如果是值类型，可以用reactive的KVO方法来监听
        ///
        ///     let producer =  self.reactive.producer(forKeyPath:
        ///     "LiveRoomViewController.shareLiveRoomViewController.currentRoomMode")
        ///     producer.startWithValues({ (value) in
        ///         print("set current live mode success.")
        ///     })
        ///     return producer
        ///
        
        return LiveRoomViewController.shareLiveRoomViewController.currentRoomModeSignalPipe.output
    }()
    
    private lazy var options: PLPlayerOption = {
        
        ///
        ///     播放器设置选项
        ///     对应的设置参数请点击进入查看官方注释
        ///
        let tOptions = PLPlayerOption.default()
        tOptions.setOptionValue(5, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
        tOptions.setOptionValue(2000, forKey: PLPlayerOptionKeyMaxL1BufferDuration)
        tOptions.setOptionValue(1000, forKey: PLPlayerOptionKeyMaxL2BufferDuration)
        //tOptions.setOptionValue(true, forKey: PLPlayerOptionKeyVideoToolbox)
        //tOptions.setOptionValue(false, forKey: PLPlayerOptionKeyVODFFmpegEnable)
        //tOptions.setOptionValue(3, forKey: PLPlayerOptionKeyLogLevel)//kPLLogInfo
        
        return tOptions
    }()
    
    ///
    ///     流播放器，这里是直接使用包装好的PLPlayer
    ///
    private var livePlayer: PLPlayer!
    
    ///
    ///     用户交互图层
    ///
    private var interactiveView: LiveRoomInteractiveView = {
        return LiveRoomInteractiveView.shareLiveRoomInteractiveView
    }()

///---------------------------------------------------
    
    public func stop() {
        guard let player = livePlayer else {
            print("*****The livePlayer is nil.*****")
            return
        }
        player.stop()
        player.launchView?.image = #imageLiteral(resourceName: "placeholder_head")
    }
    
    override func removeFromSuperview() {
        stop()
        interactiveView.removeFromSuperview()
    }

    private func setupLivePlayer(withRoomModel model: LiveRoomModel) {
        livePlayer = PLPlayer(liveWith: URL(string: model.flv ?? ""), option: self.options)
        livePlayer.delegate = self
        livePlayer.launchView?.sd_setImage(with: URL(string: model.bigpic ?? model.photo ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_head"))
        livePlayer.play()
        
        self.addSubview(livePlayer.playerView!)
        
        print("------self:", self)
        
        self.insertSubview(self.interactiveView, aboveSubview: livePlayer.playerView!)
        interactiveView.snp.makeConstraints { (make) in
            make.edges.height.equalToSuperview()
        }
        /// 调用currentAnchorModel方法
        interactiveView.currentAnchorModel = model
    }
    
///---------------------------------------------------
/// PLPlayerDelegate
///
    func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
        // 除了 Error 状态，其他状态都会回调这个方法
        // 开始播放，当连接成功后，将收到第一个 PLPlayerStatusCaching 状态
        // 第一帧渲染后，将收到第一个 PLPlayerStatusPlaying 状态
        // 播放过程中出现卡顿时，将收到 PLPlayerStatusCaching 状态
        // 卡顿结束后，将收到 PLPlayerStatusPlaying 状态
    }
    
    func player(_ player: PLPlayer, codecError error: Error) {
        // 当解码器发生错误时，会回调这个方法
        // 当 videotoolbox 硬解初始化或解码出错时
        // error.code 值为 PLPlayerErrorHWCodecInitFailed/PLPlayerErrorHWDecodeFailed
        // 播发器也将自动切换成软解，继续播放
    }
    
    func player(_ player: PLPlayer, stoppedWithError error: Error?) {
        // 当发生错误，停止播放时，会回调这个方法
    }
}
