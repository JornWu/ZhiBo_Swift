//
//  LiveRoomViewController.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/4/26.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

protocol LiveRoomViewControllerDelegate {
///
///     这是LiveRoomViewController必须实现的三个方法
///
    
    ///
    ///     给直播控制器传入数据
    ///
    func setRoomDatas(withDataAr dataAr: [AnyObject])
    
    ///
    ///     设置当前的直播间
    ///
    func setCurrentRoomIndex(index: Int)
    
    ///
    ///     打开要进入的直播间
    ///
    func openCurrentRoom()
}

private let instance = LiveRoomViewController()

final class LiveRoomViewController:
    UIViewController,
    LiveRoomViewControllerDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate {
    
///---------------------------------------------------
/// Singleton
///

///
///    单例的实现
///    static let shareLiveRoomViewController = LiveRoomViewController()
///
///    static var shareLiveRoomViewController: LiveRoomViewController {
///        struct Singleton {
///            static var instance = LiveRoomViewController()
///        }
///        return Singleton.instance
///    }
///
    
    final class var shareLiveRoomViewController: LiveRoomViewController {
        return instance
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
///---------------------------------------------------
/// property
///
    ///
    ///     直播间数据
    ///
    private lazy var roomDataAr: [LiveRoomModel] = {
        return [LiveRoomModel]()
    }()
    
    ///
    ///     直播间列表
    ///
    private var roomCollectionView: UICollectionView!
    
    ///
    ///     直播间（播放视图）
    ///
    private lazy var liveRoomView: LiveRoomView = {
        return LiveRoomView.shareLiveRoomView
    }()
    
    ///
    ///     当前房间（用于定位初始化进入的直播间）
    ///
    public var currentRoomIndex: Int = 0
    
    ///
    ///     当前直播间数据模型（信号）
    ///
    public lazy var currentRoomModeSignalPipe: (output: Signal<LiveRoomModel, NoError>, input: Observer<LiveRoomModel, NoError>) = {
        return Signal<LiveRoomModel, NoError>.pipe()
    }()
    
    ///
    ///     ViewModel
    ///
    private lazy var liveRoomViewControllerViewModel: LiveRoomViewControllerViewModel = {
        return LiveRoomViewControllerViewModel()
    }()
    
///---------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    ///
    ///     退出直播列表
    ///
    override func viewWillDisappear(_ animated: Bool) {
        liveRoomView.stop()
        currentRoomIndex = 0
    }
    
    ///
    ///     进入点击的直播间
    ///
    override func viewDidAppear(_ animated: Bool) {
        openCurrentRoom()
    }
    
///---------------------------------------------------
/// LiveRoomViewControllerDelegate
///
    public func setRoomDatas(withDataAr dataAr: [AnyObject]) {
        self.roomDataAr.removeAll()
        for item in dataAr {
            self.roomDataAr.append(LiveRoomModel.modelWith(item))
        }
        
        if roomCollectionView != nil {
            roomCollectionView.reloadData()
        }
        else {
            self.setupCollectionView()
        }
    }
    
    public func setCurrentRoomIndex(index: Int) {
        currentRoomIndex = index
    }
    
    internal func openCurrentRoom() {
        
        if self.roomCollectionView != nil {
            
            self.roomCollectionView.contentOffset = CGPoint(x: 0, y: Int(self.view.frame.height) * currentRoomIndex)
            
            ///
            ///     这种方法返回的cell回空，不好使
            ///
            ///     let roomCell = roomCollectionView.cellForItem(at: IndexPath(row: currentRoomIndex, 
            ///     section: 0))
            ///     if let cell = roomCell {
            ///         cell.contentView.addSubview(self.liveRoomView)
            ///         self.liveRoomView.snp.makeConstraints { (make) in
            ///             make.edges.height.equalToSuperview()
            ///         }
            ///     }
            ///
            let cells = roomCollectionView.visibleCells
            if cells.count > 0 {
                cells[0].contentView.addSubview(self.liveRoomView)
                self.liveRoomView.snp.makeConstraints { (make) in
                    make.edges.height.equalToSuperview()
                }
                
                print("------cells[0].contentView:", cells[0].contentView)
            }
            
            ///     这个方法要放在self.liveRoomView之后，因为self.liveRoomView会调用懒加载
            ///     在LiveRoomView.shareLiveRoomView内部中会监听currentRoomModeSignalPipe的信号
            ///     否则会漏掉第一次发送的数据
            ///     ## 如果roomDataAr[currentRoomIndex]是值类型，其实可以使用reactive的KOV来实现，或者监听方法来实现 ##
            self.currentRoomModeSignalPipe.input.send(value: self.roomDataAr[currentRoomIndex])
        }
    }
    
///---------------------------------------------------------------
/// 构建热门主视图
///
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.view.frame.size
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        roomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        roomCollectionView.dataSource = self
        roomCollectionView.delegate = self
        roomCollectionView.bounces = false
        roomCollectionView.isPagingEnabled = true
        roomCollectionView.backgroundColor = UIColor.orange
        self.view.addSubview(roomCollectionView)
        roomCollectionView.snp.makeConstraints { (make) in
            make.edges.height.equalToSuperview()
        }
        
        roomCollectionView.register(LiveRoomCollectionViewCell.self, forCellWithReuseIdentifier: "LiveRoomCell")
        
        NotificationCenter.default
            .reactive
            .notifications(forName: NSNotification.Name.UIDeviceOrientationDidChange)
            .observeValues { (noti) in
            self.roomCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
          numberOfItemsInSection section: Int) -> Int {
        return roomDataAr.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dataItem = roomDataAr[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveRoomCell",
                                                                      for: indexPath) as! LiveRoomCollectionViewCell
        cell.setupCell(withImageURLString: dataItem.bigpic ?? dataItem.photo ?? "",
                            flvLinkString: dataItem.flv ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
             layout collectionViewLayout: UICollectionViewLayout,
                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                   didEndDisplaying cell: UICollectionViewCell,
                     forItemAt indexPath: IndexPath) {
        
        let index = Int((collectionView.contentOffset.y + 5) / collectionView.frame.height)
        
        if currentRoomIndex != index {
            
            currentRoomIndex = index
            
            ///
            /// 从前一个cell中移出
            ///
            self.liveRoomView.removeFromSuperview()
            
            ///
            /// 如果roomDataAr[currentRoomIndex]是值类型，可以直接调用setter，产生信号
            ///
            self.currentRoomModeSignalPipe.input.send(value: self.roomDataAr[currentRoomIndex])
            
            let cell = roomCollectionView.cellForItem(at: IndexPath(row: currentRoomIndex, section: 0))
            cell?.contentView.addSubview(self.liveRoomView)
            if cell != nil {
                self.liveRoomView.snp.makeConstraints { (make) in
                    make.edges.height.equalToSuperview()
                }
            }
        }
    }
    
    
///---------------------------------------------------
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
