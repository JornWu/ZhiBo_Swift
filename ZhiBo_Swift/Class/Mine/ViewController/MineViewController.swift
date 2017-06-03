//
//  MineViewController.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/2/27.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class MineViewController:
BaseViewController,
UITableViewDelegate,
UITableViewDataSource {
    private lazy var itemsTitle: Array = {
        return [
            ["我的喵币", "直播间管理", "号外！做任务赢礼包~"],
            ["我的收益", "游戏中心"],
            ["设置"]
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = VIEW_BACKGROUND_COLOR
        self.setupContentView()
    }
    
    private func setupContentView() {
        ///
        /// main tableView
        ///
        let tableView = { () -> UITableView in
            let tbView = UITableView(frame: .zero, style: .grouped)
            tbView.backgroundColor = UIColor.white
            tbView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            self.view.addSubview(tbView)
            tbView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
                make.top.equalTo(-21)
            })
            
            tbView.dataSource = self
            tbView.delegate = self
            
            return tbView
        }()
        
        ///
        /// profile view
        ///
        let headerView = { () -> UIView in
            let view = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                        width: self.view.bounds.width,
                                       height: self.view.bounds.height * 2 / 5))
            view.backgroundColor = VIEW_BACKGROUND_COLOR
            tableView.tableHeaderView = view
            return view
        }()
        
        let iconBtn = { () -> UIButton in
            let profileIcon = UIButton()
            profileIcon.setImage(#imageLiteral(resourceName: "jiaIcon"), for: .normal)
            headerView.addSubview(profileIcon)
            profileIcon.layer.cornerRadius = 50
            profileIcon.layer.borderWidth = 2
            profileIcon.layer.borderColor = UIColor.white.cgColor
            profileIcon.clipsToBounds = true
            profileIcon.isHighlighted = false
            profileIcon.snp.makeConstraints({ (make) in
                make.left.equalTo(30)
                make.top.equalTo(80)
                make.size.equalTo(CGSize(width: 100, height: 100))
            })
            
            let tips = UILabel()
            tips.text = "Edit..."
            tips.font = UIFont.systemFont(ofSize: 11)
            tips.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.7)
            tips.textColor = UIColor.black
            tips.textAlignment = .center
            //tips.isHidden = true
            profileIcon.addSubview(tips)
            tips.snp.makeConstraints({ (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(20)
            })
            
            profileIcon.reactive.controlEvents(.touchUpInside).observeValues({ (btn) in
                ///从相册中获取新图片
                //btn.setImage(#imageLiteral(resourceName: "toolbar_me_sel"), for: .normal)
            })
            
            return profileIcon
        }()
        
        let nameLB = { () -> UILabel in
            let name = UILabel()
            name.text = "24K纯帅"
            name.font = UIFont.systemFont(ofSize: 20)
            headerView.addSubview(name)
            name.snp.makeConstraints({ (make) in
                make.top.equalTo(iconBtn.snp.top)
                make.left.equalTo(iconBtn.snp.right).offset(20)
                make.right.equalToSuperview().offset(-100)
                make.height.equalTo(30)
            })
            return name
        }()
        
        let expView = { () -> UIView in
            let experience = UIView()
            experience.clipsToBounds = true
            headerView.addSubview(experience)
            experience.snp.makeConstraints({ (make) in
                make.top.equalTo(nameLB.snp.bottom).offset(5)
                make.left.equalTo(nameLB.snp.left)
                make.right.equalTo(-30)
                make.height.equalTo(10)
            })
            
            experience.layer.cornerRadius = 5
            experience.layer.backgroundColor = UIColor.gray.cgColor
            
            ///可以用UIView，同时可以用snpkit
            let expLayer = CALayer()
            expLayer.backgroundColor = THEME_COLOR.cgColor
            experience.layer.addSublayer(expLayer)
            expLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 10)
            
            return experience
        }()
        
        
        let idLB = { () -> UILabel in
            let id = UILabel()
            id.text = "IDX: 12345678"
            id.font = UIFont.systemFont(ofSize: 15)
            headerView.addSubview(id)
            id.snp.makeConstraints({ (make) in
                make.top.equalTo(expView.snp.bottom).offset(5)
                make.left.equalTo(nameLB.snp.left)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(30)
            })
            return id
        }()
        
        let describeLB = { () -> UILabel in
            let describe = UILabel()
            describe.text = "欢迎来到英雄联盟，敌军还有30秒钟到达战场。"
            describe.font = UIFont.systemFont(ofSize: 15)
            describe.numberOfLines = 0
            headerView.addSubview(describe)
            describe.snp.makeConstraints({ (make) in
                make.top.equalTo(idLB.snp.bottom).offset(10)
                make.left.equalTo(nameLB.snp.left)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(60)
            })
            return describe
        }()
        
        
        _ = {
            let container = UIView()
            headerView.addSubview(container)
            container.snp.makeConstraints({ (make) in
                make.left.bottom.right.equalToSuperview()
                make.top.equalTo(describeLB.snp.bottom).offset(5)
            })
            
            let subscribeNum = UIButton()
            subscribeNum.setTitle("关注：103", for: .normal)
            subscribeNum.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            container.addSubview(subscribeNum)
            subscribeNum.snp.makeConstraints({ (make) in
                make.top.left.bottom.equalToSuperview()
                make.width.equalToSuperview().dividedBy(3.33)
            })
            
            let fansNum = UIButton()
            fansNum.setTitle("粉丝：4508万", for: .normal)
            fansNum.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            container.addSubview(fansNum)
            fansNum.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(subscribeNum.snp.right)
                make.width.equalToSuperview().dividedBy(3.33)
            })
            
            let liveHour = UIButton()
            liveHour.setTitle("直播时长：约34小时", for: .normal)
            liveHour.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            container.addSubview(liveHour)
            liveHour.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(fansNum.snp.right)
                make.right.equalToSuperview()
            })
        }()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///no resuse
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "mineCell")
        cell.textLabel?.text = self.itemsTitle[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.imageView?.image = #imageLiteral(resourceName: "me_new_zhanghao")
            cell.detailTextLabel?.text = "130~ Billion"
            cell.detailTextLabel?.textColor = NORMAL_TEXT_COLOR
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        }
        else if indexPath.section == 1 && indexPath.row == 0 {
            cell.imageView?.image = #imageLiteral(resourceName: "me_new_shouyi")
            cell.detailTextLabel?.text = "20~ million"
            cell.detailTextLabel?.textColor = NORMAL_TEXT_COLOR
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        }
        else {
            cell.imageView?.image = #imageLiteral(resourceName: "good5_30x30")
        }
        
        return cell
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
