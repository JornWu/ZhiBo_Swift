//
//  NewView.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/3/2.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class NewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private lazy var newViewModel = {
        return NewViewModel()
    }()
    
    private lazy var newRoomOnlineDataAr: [NR_List] = {
        return [NR_List]()
    }()
    
    private var newRoomOnlineCollectionView: UICollectionView!
    
    private lazy var liveRoomVC: LiveRoomViewController = {
        let vc = LiveRoomViewController.shareLiveRoomViewController
        vc.setRoomDatas(withDataAr: self.newRoomOnlineDataAr)
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
        
        getNemRoomOnlineData()
    }
    
    private func getNemRoomOnlineData() {
        self.newViewModel.getNewRoomOnlineSignal.observe {
            //[weak self]
            event in
            switch event {
            case let .value(results):
                DispatchQueue.main.sync(execute: {
                    guard results != nil else {
                        return
                    }
                    self.newRoomOnlineDataAr = results!
                    self.setupNewRoomOnlineCollectionView()
                })
            case let .failed(error):
                print("Search adDataAr error: \(error)")
            case .completed, .interrupted:
                break
            }
        }
    }
    
    private func setupNewRoomOnlineCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.width - 1) * 0.332, height: (self.view.frame.width - 1) * 0.332)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 2
        self.newRoomOnlineCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.newRoomOnlineCollectionView.dataSource = self
        self.newRoomOnlineCollectionView.delegate = self
        self.newRoomOnlineCollectionView.bounces = false
        self.newRoomOnlineCollectionView.showsVerticalScrollIndicator = false
        self.newRoomOnlineCollectionView.register(NewRoomOnlineCell.self, forCellWithReuseIdentifier: "newRoomOnlineCell")
        self.view.addSubview(self.newRoomOnlineCollectionView)
        
        self.newRoomOnlineCollectionView.snp.makeConstraints { (make) in
            make.edges.height.equalToSuperview()
        }
        
        NotificationCenter.default.reactive.notifications(forName: NSNotification.Name.UIDeviceOrientationDidChange).observeValues { (noti) in
            self.newRoomOnlineCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newRoomOnlineDataAr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataItem = newRoomOnlineDataAr[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newRoomOnlineCell", for: indexPath) as! NewRoomOnlineCell
        cell.setupCell(nickName: dataItem.nickname, isNew: dataItem.newField, position: dataItem.position, starLevel: dataItem.starlevel, backgroundImagURLString: dataItem.photo, roomLink: dataItem.flv)
        
        cell.actionSignal.observeValues {
            [weak self]
            (button) in
            
            guard let weakSelf = self else {
                return
            }
            
            NewViewController.currentCellSignalPipe.input.send(value: indexPath.row)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let rootVC = appDelegate.window?.rootViewController
            rootVC?.present(weakSelf.liveRoomVC, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 1) * 0.332, height: (self.view.frame.width - 1) * 0.332)
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
