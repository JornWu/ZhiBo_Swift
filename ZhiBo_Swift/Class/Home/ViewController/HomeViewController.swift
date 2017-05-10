//
//  HomeViewController.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/2/27.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: BaseViewController, UIViewControllerTransitioningDelegate, UIScrollViewDelegate {
    
    ///点击“广场”按钮展开的下拉视图
    private var dropDownMaskView: UIView!
    
    ///首页类别标签选择的滚动视图
    private var labelSelectScrollView: UIScrollView!
    ///标签下的pageControl
    private var pageCtrl: UIView!
    
    ///右侧展开的种类标签按钮的容器视图
    private var labelButtonContainerVC: UIViewController!
    
    ///中间的主视图
    private var mainView: UIScrollView!
    private var mainContentView: UIView!
    ///热门中的内容视图
    private var hotView: UIView!
    ///最新中的内容视图
    private var newView: UIView!
    ///关注中的内容视图
    private var loveView: LoveView!
    
    ///首页控制器对应的VM，处理首页中的所有业务逻辑
    private lazy var homeVM: HomeViewModel = {
        return HomeViewModel()
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.createNavigationButtons()
        self.createDropDownView()
        self.createLabelScrollView()
        self.createLabelButtonContainerVC()
        self.createMainView()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBar_bg_414x70"), for: UIBarMetrics.default)
    }
    
    func createNavigationButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search_15x14"), style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "head_crown_24x24"), style: .done, target: self, action: #selector(showRankingList))
        
        let titleBtn = UIButton(type: .custom)
        titleBtn.setTitle("广场", for: .normal)
        titleBtn.setTitleColor(UIColor.white, for: .normal)
        titleBtn.setImage(#imageLiteral(resourceName: "title_down_9x16"), for: .normal)
        titleBtn.setImage(#imageLiteral(resourceName: "title_up_9x16"), for: .selected)
        titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, -30)
        titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 30)
        titleBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        self.navigationItem.titleView = titleBtn
        
        //titleBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
        
        titleBtn.addTarget(self, action: #selector(showDropDownView(clickedButton:)), for: .touchUpInside)
    }
    
    func showRankingList() {
        self.navigationController?.pushViewController(RankingListViewController(), animated: true)
    }
    
    func showDropDownView(clickedButton button: UIButton) {
        self.dropDownMaskView.isHidden = button.isSelected
        button.isSelected = !button.isSelected
    }
    
    func createDropDownView() {
        dropDownMaskView = UIView()
        dropDownMaskView.isHidden = true
        dropDownMaskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.view.addSubview(dropDownMaskView)
        
        let dropDownView = UIView()
        dropDownView.backgroundColor = UIColor.gray
        dropDownMaskView.addSubview(dropDownView)
        
        dropDownMaskView.snp.makeConstraints {(make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        dropDownView.snp.makeConstraints {(make) in
            //make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 500, 0))
            //make.top.equalTo(self.view).offset(0)
            //make.left.equalTo(self.view).offset(0)
            //make.right.equalTo(self.view).offset(0)
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(150)
        }
    }
    
    func createLabelScrollView() {
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        self.view.insertSubview(containerView, at: 0)
        
        
        labelSelectScrollView = UIScrollView()///这里只设三个标签，如果更多的话，会用到滚动视图
        //labelSelectScrollView.backgroundColor = UIColor.cyan;
        containerView.addSubview(labelSelectScrollView)
        
        let foldBtn = UIButton()
        foldBtn.setTitle("Open", for: .normal)
        foldBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        foldBtn.backgroundColor = UIColor.brown
        containerView.addSubview(foldBtn)
        foldBtn.addTarget(self, action: #selector(showLabelButtonContainerView), for: .touchUpInside)
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(40)
        }
        
        labelSelectScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(-40)
            make.height.equalTo(40)
        }
        
        foldBtn.snp.makeConstraints { (make) in
            make.top.equalTo(labelSelectScrollView.snp.top)
            make.right.lessThanOrEqualTo(0)
            make.width.height.equalTo(40)
        }
        
        let hotLabelBtn = UIButton(type: .custom)
        hotLabelBtn.setTitle("最热", for: .normal)
        hotLabelBtn.setTitleColor(UIColor(red: 223.0 / 225.0,
                                          green: 55.0 / 255.0,
                                          blue: 125.0 / 255.0,
                                          alpha: 1), for: .normal) ///默认选择热门这个标签
        hotLabelBtn.tag = 100
        //hotLabelBtn.backgroundColor = UIColor.blue
        hotLabelBtn.addTarget(self, action: #selector(labelButtonAction(clickedButton:)), for: .touchUpInside)
        
        let newLabelBtn = UIButton(type: .custom)
        newLabelBtn.setTitle("最新", for: .normal)
        newLabelBtn.setTitleColor(UIColor(red: 106.0 / 225.0,
                                          green: 37.0 / 255.0,
                                          blue: 99.0 / 255.0,
                                          alpha: 1), for: .normal)
        newLabelBtn.tag = 101
        //newLabelBtn.backgroundColor = UIColor.gray
        newLabelBtn.addTarget(self, action: #selector(labelButtonAction(clickedButton:)), for: .touchUpInside)
        
        let loveLabelBtn = UIButton(type: .custom)
        loveLabelBtn.setTitle("关注", for: .normal)
        loveLabelBtn.setTitleColor(UIColor(red: 106.0 / 225.0,
                                           green: 37.0 / 255.0,
                                           blue: 99.0 / 255.0,
                                           alpha: 1), for: .normal)
        loveLabelBtn.tag = 102
        //loveLabelBtn.backgroundColor = UIColor.blue
        loveLabelBtn.addTarget(self, action: #selector(labelButtonAction(clickedButton:)), for: .touchUpInside)
        
        labelSelectScrollView.contentSize = labelSelectScrollView.frame.size
        labelSelectScrollView.addSubview(hotLabelBtn)
        labelSelectScrollView.addSubview(newLabelBtn)
        labelSelectScrollView.addSubview(loveLabelBtn)
        
        hotLabelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(labelSelectScrollView).offset(0)
            make.left.equalTo(labelSelectScrollView).offset(0)
            make.height.equalTo(labelSelectScrollView).offset(-2)
            make.width.equalTo(labelSelectScrollView.snp.width).multipliedBy(0.333)
        }
        
        newLabelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(hotLabelBtn)
            make.bottom.equalTo(hotLabelBtn)
            make.left.equalTo(hotLabelBtn.snp.right)
            make.width.equalTo(hotLabelBtn)
        }
        
        loveLabelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(hotLabelBtn)
            make.bottom.equalTo(hotLabelBtn)
            make.left.equalTo(newLabelBtn.snp.right)
            make.width.equalTo(hotLabelBtn)
        }
        
        pageCtrl = UIView() ///模拟pageControl
        pageCtrl.backgroundColor = UIColor(red: 223.0 / 225.0, green: 55.0 / 255.0, blue: 125.0 / 255.0, alpha: 1)
        labelSelectScrollView.addSubview(pageCtrl)
        pageCtrl.snp.makeConstraints { (make) in
            make.width.equalTo(labelSelectScrollView).multipliedBy(0.333)
            make.height.equalTo(2)
            make.left.equalTo(0)///默认选择热门这个标签
            make.top.equalTo(hotLabelBtn.snp.bottom)
        }
        
    }
    
    func createLabelButtonContainerVC() {
        labelButtonContainerVC = UIViewController()
        labelButtonContainerVC.view.backgroundColor = UIColor.orange
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.gray
        labelButtonContainerVC.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 300, height: 200))
            make.center.equalTo(labelButtonContainerVC.view)
        }
        
        let labelArr = ["最热", "最新", "关注"]
        for index in 0..<labelArr.count {
            let labelBtn = UIButton(type: .custom)
            labelBtn.setTitle(labelArr[index], for: .normal)
            labelBtn.backgroundColor = UIColor.blue
            labelBtn.tag = index + 100 ///与之前的hotLabelBtn等对应
            labelBtn.addTarget(self, action: #selector(labelButtonAction(clickedButton:)), for: .touchUpInside)
            labelBtn.backgroundColor = UIColor(red: CGFloat(index) * 25.0 / 255.0, green: CGFloat(index) * 45.0 / 255.0, blue: CGFloat(index) * 65.0 / 255.0, alpha: 1)
            bgView.addSubview(labelBtn)
            
            let row = labelArr.count % 2 + labelArr.count / 2
            let r = index / 2
            let c = index % 2
            labelBtn.snp.makeConstraints({ (make) in
                make.width.equalTo(bgView.snp.width).multipliedBy(0.5)
                make.height.equalTo(bgView.snp.height).dividedBy(row)
                if r == 0 {
                    make.top.equalTo(0)
                }
                else if r == 1 {
                    make.bottom.equalTo(0)
                }
                
                if c == 0 {
                    make.left.equalTo(0)
                }
                else if c == 1 {
                    make.right.equalTo(0)
                }
            })
        }
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.setTitle("Close", for: .normal)
        closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        closeBtn.addTarget(self, action: #selector(closeLabelButtonContainerView), for: .touchUpInside)
        labelButtonContainerVC.view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 30))
            make.top.equalTo(40)
            make.right.equalTo(-20)
        }
    }
    
    func showLabelButtonContainerView() {
        /*
         * tips：系统没有提供从右侧弹出模态视图的style，可以才用自定义的style来实现，要做的事有点多
         * 也可以采用平移视图的的方式，而labelButtonContainerVC可以换成UIView类型
         */
        
        self.present(labelButtonContainerVC, animated: true, completion: nil)
        //self.modalPresentationStyle = .custom ///自定义
        //self.transitioningDelegate = self
    }
    
    func closeLabelButtonContainerView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*-------------------------transitioningDelegate------------------------*/
    /*
     * 该代理方法用于返回负责转场的控制器对象
     */
    /*
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        <#code#>
    }
    
    /*
     * 该代理方法用于告诉系统谁来负责控制器如何弹出
     */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        <#code#>
    }
    
    /*
     * 该该代理方法用于告诉系统谁来负责控制器如何消失
     */
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        <#code#>
    }
    
    /*
     * 该该代理方法用于告诉系统谁来负责控制器如何消失
     */
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
    }
    
    /*
     * 该该代理方法用于告诉系统谁来负责控制器如何消失
     */
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
    }
    */
    
    /*
     * 标签点击的响应方法
     */
    func labelButtonAction(clickedButton button: UIButton) {
        closeLabelButtonContainerView()
        let index = button.tag - 100
        UIView.animate(withDuration: 0.3) {
            [unowned self] in
            self.pageCtrl.frame.origin.x = self.pageCtrl.frame.width * CGFloat(index)
        }
        
        ///设置当前标签的文字颜色
        for btn in labelSelectScrollView.subviews {
            if btn.tag == button.tag {///因为有可能是LabelButtonContainerVC里的按钮
                if btn is UIButton {
                    (btn as! UIButton).setTitleColor(THEME_COLOR, for: .normal)
                }
            }
            else {
                if btn is UIButton {
                    (btn as! UIButton).setTitleColor(NORMAL_TEXT_COLOR, for: .normal)
                }
            }
        }
        
        ///选择当前的主视图
        mainView.contentOffset = CGPoint(x: mainView.frame.width * CGFloat(index), y: CGFloat(0))
    }
    
    /*
     * 创建中间的主视图
     */
    func createMainView() {
        mainView = UIScrollView()
        mainView.backgroundColor = UIColor.cyan
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        mainView.isPagingEnabled = true
        mainView.bounces = false
        mainView.delegate = self
        self.view.insertSubview(mainView, at: 0)
        
        mainView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(40, 0, 0, 0))
        }
        
        mainContentView = UIView()
        mainContentView.backgroundColor = UIColor.gray
        mainView.addSubview(mainContentView)
        
        mainContentView.snp.makeConstraints { (make) in
            make.edges.height.equalToSuperview()
        }
        
        hotView = HotViewController().view
        hotView.backgroundColor = UIColor.white
        mainContentView.addSubview(hotView)
        
        newView = NewViewController().view
        newView.backgroundColor = UIColor.white
        mainContentView.addSubview(newView)
        
        loveView = LoveView()
        loveView.backgroundColor = UIColor.white
        mainContentView.addSubview(loveView)
        
        hotView.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview()
            make.width.equalTo(mainView)
        }
        
        newView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(hotView.snp.right)
            make.width.equalTo(mainView)
        }
        
        loveView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(newView.snp.right)
            make.width.equalTo(mainView)
        }
        
        mainContentView.snp.makeConstraints { (make) in
            make.right.equalTo(loveView)
        }
    }
    
    ///滑动主视图时的代理方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if scrollView.frame.width > 0 {
            let index = Int(offset.x / scrollView.frame.width)
            
            for btn in labelSelectScrollView.subviews {
                if btn.tag == (index + 100) {///因为有可能是LabelButtonContainerVC里的按钮
                    if btn is UIButton {
                        (btn as! UIButton).setTitleColor(THEME_COLOR, for: .normal)
                        UIView.animate(withDuration: 0.3) {
                            [unowned self] in
                            self.pageCtrl.frame.origin.x = self.pageCtrl.frame.width * CGFloat(index)
                        }
                    }
                }
                else {
                    if btn is UIButton {
                        (btn as! UIButton).setTitleColor(NORMAL_TEXT_COLOR, for: .normal)
                    }
                }
            }
        }
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
