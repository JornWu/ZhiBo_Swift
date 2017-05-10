//
//  HotView.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/3/2.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class HotViewController: BaseViewController, UIScrollViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private lazy var hotViewModel = {
        return HotViewModel()
    }()
    
    private lazy var adDataAr: [AD_Data] = {
        return [AD_Data]()
    }()
    
    private var topPageControl: UIPageControl!
    private var topADView: UIScrollView!
    
    private lazy var hotListDataAr: [HL_List] = {
        return [HL_List]()
    }()
    
    private var hotLiveCollectionView: UICollectionView!
    
    private lazy var liveRoomVC: LiveRoomViewController = {
        let vc = LiveRoomViewController.shareLiveRoomViewController
        vc.setRoomDatas(withDataAr: self.hotListDataAr)
        return vc
    }()
    
    class var currentCellSignalPipe: (output: Signal<Int, NoError>, input: Observer<Int, NoError>) {
        let pipe = Signal<Int, NoError>.pipe()
        pipe.output.observeValues { (value) in
            LiveRoomViewController.shareLiveRoomViewController.setCurrentRoomIndex(index: value)
        }
        return pipe
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getADData()
        getHotLiveData()
    }
 
///---------------------------------------------------------------
/// 获取网络数据
///
    ///获取广告数据
    func getADData() {
        self.hotViewModel.getADSignale.observe {
            //[weak self]
            event in
            switch event {
            case let .value(results):
                DispatchQueue.main.sync(execute: {
                    guard results != nil else {
                        return
                    }
                    self.adDataAr = results!
                    self.setupAdView(withData: results)
                })
            case let .failed(error):
                print("Search adDataAr error: \(error)")
            case .completed, .interrupted:
                break
            }
        }
    }
    
    ///获取热门数据
    private func getHotLiveData() {
        self.hotViewModel.getHotListSignal.observe {
            //[weak self]
            event in
            switch event {
            case let .value(results):
                DispatchQueue.main.sync(execute: {
                    guard results != nil else {
                        return
                    }
                    self.hotListDataAr = results!
                    self.setupHotLiveTableView()
                })
            case let .failed(error):
                print("Search hotListDataAr error: \(error)")
            case .completed, .interrupted:
                break
            }
        }
    }
    
///---------------------------------------------------------------
/// 设置顶部的滚动广告
///
    private func setupAdView(withData data: [AD_Data]?) {
        guard data == nil else {
            let containerView = UIView()
            self.view.addSubview(containerView)
            containerView.snp.makeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(TOP_AD_VIEW_HEIGHT)
            })
            
            topADView = UIScrollView()
            topADView.bounces = false
            topADView.isPagingEnabled = true
            topADView.showsVerticalScrollIndicator = false
            topADView.showsHorizontalScrollIndicator = false
            topADView.delegate = self
            containerView.addSubview(topADView)
            topADView.snp.makeConstraints({ (make) in
                make.left.top.right.equalTo(0)
                make.height.equalTo(TOP_AD_VIEW_HEIGHT)
            })
            
            let contenView = UIView()
            topADView.addSubview(contenView)
            contenView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
                make.height.equalToSuperview()
            })
            
            var preView: LinkButton? = nil
            for dateItem in data! {
                let singAdView = LinkButton()
                singAdView.adjustsImageWhenHighlighted = false
                singAdView.link = dateItem.link
                singAdView.sd_setBackgroundImage(with: URL(string: dateItem.imageUrl), for: .normal, placeholderImage: #imageLiteral(resourceName: "placeHolder_ad_414x100"))
                contenView.addSubview(singAdView)
                
                //singAdView.reactive.controlEvents(.touchUpInside)
                
                if preView == nil {
                    singAdView.snp.makeConstraints({ (make) in
                        make.top.bottom.width.equalTo(topADView)
                        make.left.equalToSuperview()
                    })
                }
                else {
                    singAdView.snp.makeConstraints({ (make) in
                        make.top.bottom.width.equalTo(topADView)
                        make.left.equalTo(preView!.snp.right)
                    })
                }
                preView = singAdView
            }
            contenView.snp.makeConstraints({ (make) in
                make.right.equalTo(preView!.snp.right)
            })
 
            topPageControl = UIPageControl()
            topPageControl.numberOfPages = data!.count
            containerView.addSubview(topPageControl)
            topPageControl.snp.makeConstraints({ (make) in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(20)
            })
            
            return
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if scrollView.frame.width > 0 {
            let index = Int(offset.x / scrollView.frame.width)
            topPageControl.currentPage = index
        }
    }
    
///---------------------------------------------------------------
/// 构建热门主视图
///
    private func setupHotLiveTableView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.width - 1) * 0.5, height: (self.view.frame.width - 1) * 0.5)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        self.hotLiveCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        self.hotLiveCollectionView.dataSource = self
        self.hotLiveCollectionView.delegate = self
        self.hotLiveCollectionView.bounces = false
        self.hotLiveCollectionView.showsVerticalScrollIndicator = false
        self.hotLiveCollectionView.register(HotListCell.self, forCellWithReuseIdentifier: "hotListCell")
        self.view.addSubview(self.hotLiveCollectionView)
        
        self.hotLiveCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(80)
            make.left.right.bottom.equalToSuperview()
        }
        
        NotificationCenter.default.reactive.notifications(forName: NSNotification.Name.UIDeviceOrientationDidChange).observeValues { (noti) in
            self.hotLiveCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotListDataAr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = hotListDataAr[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotListCell", for: indexPath) as! HotListCell
        cell.setupCell(nickName: item.myname, starLevel: item.starlevel, category: item.familyName, liveMark: #imageLiteral(resourceName: "home_live_43x22"), number: item.allnum, backgroundImagURLString: item.bigpic, roomLink: item.flv)
        
        cell.actionSignal.observeValues {
            [weak self]
            (button) in
            
            guard let weakSelf = self else {
                return
            }
            
            HotViewController.currentCellSignalPipe.input.send(value: indexPath.row)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let rootVC = appDelegate.window?.rootViewController
            rootVC?.present(weakSelf.liveRoomVC, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 1) * 0.5, height: (collectionView.frame.width - 1) * 0.5)
    }
    
    
    
    
///---------------------------------------------------------------
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
