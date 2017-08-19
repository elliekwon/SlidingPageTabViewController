//
//  SlidingPageTabViewController.swift
//
//  Copyright © 2017 Ellie Kwon. All rights reserved.
//

import UIKit

class SlidingPageTabViewController: UIViewController {

  var pageInfos: Array<Dictionary<String, Any>>! {
    didSet {
      self.numberOfPage = pageInfos.count
    }
  }

  fileprivate var numberOfPage = 0

  fileprivate var menuBarView: UIView!
  fileprivate var menuUnderLineView: UIView!
  fileprivate var menuUnderLineViewLeftConstraint: NSLayoutConstraint!

  fileprivate var contentCollectionView: UICollectionView!

  init(_ infos: Array<Dictionary<String, Any>>) {
    super.init(nibName: nil, bundle: nil)

    ({ self.pageInfos = infos })()

    self.pageInfos = [["first": FirstViewController()],
                      ["second": SecondViewController()],
                      ["third": ThirdViewController()]]
    self.pageInfos = infos
    self.numberOfPage = pageInfos.count
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    menuBarView = UIView()
    menuUnderLineView = UIView()

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width:self.view.frame.width , height:self.view.frame.height)
    layout.minimumLineSpacing = 0.0

    contentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    contentCollectionView.register(PageCell.self, forCellWithReuseIdentifier: PageCell.identifier)
    contentCollectionView.isPagingEnabled = true
    contentCollectionView.showsHorizontalScrollIndicator = false

    self.view.addSubview(menuBarView)
    self.menuBarView.addSubview(menuUnderLineView)
    self.view.addSubview(contentCollectionView)

    menuBarView.translatesAutoresizingMaskIntoConstraints = false
    menuUnderLineView.translatesAutoresizingMaskIntoConstraints = false
    contentCollectionView.translatesAutoresizingMaskIntoConstraints = false

    contentCollectionView.dataSource = self
    contentCollectionView.delegate = self

    let views: [String:Any]
    views = ["menuBarView": menuBarView, "contentCollectionView": contentCollectionView, "menuUnderLineView": menuUnderLineView]
    let horizontalConstraintsForMenu = NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuBarView]|",
                                                               options: .alignAllLeft,
                                                               metrics: nil,
                                                               views: views)
    let horizontalConstraintsForContent = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentCollectionView]|",
                                                               options: .alignAllLeft,
                                                               metrics: nil,
                                                               views: views)
    let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[menuBarView(50)][menuUnderLineView(3)][contentCollectionView]|",
                                                               options: .alignAllLeft,
                                                               metrics: nil,
                                                               views: views)
    self.view.addConstraints(horizontalConstraintsForMenu)
    self.view.addConstraints(horizontalConstraintsForContent)
    self.view.addConstraints(verticalConstraints)

    let screenSize: CGRect = UIScreen.main.bounds

    menuUnderLineViewLeftConstraint = NSLayoutConstraint.init(item: menuUnderLineView,
                                                              attribute: .left, relatedBy: .equal, toItem: menuBarView,
                                                              attribute: .left, multiplier: 1.0, constant: 0.0)
    let menuUnderLineViewWidthConstraint = NSLayoutConstraint.init(item: menuUnderLineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenSize.width/CGFloat(self.numberOfPage))

    self.view.addConstraint(menuUnderLineViewLeftConstraint)
    self.view.addConstraint(menuUnderLineViewWidthConstraint)

    menuUnderLineView.backgroundColor = UIColor.darkGray

    setupMenus()
  }

  fileprivate func setupMenus() {
    //guard numberOfPage > 0, pageInfoDic.count > 0 else {return}

    var index = 0
    var buttons: [String:UIButton] = [:]
    var horizontalVisualFormat = ""

    for dic in pageInfos {
      let menuName = dic.first?.key

      let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
      button.setTitle(menuName, for: .normal)
      button.setTitleColor(UIColor.darkGray, for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      self.menuBarView.addSubview(button)

      let key = String(format: "button%d", index)
      let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[\(key)]|",
                                                                 options: .alignAllLeft,
                                                                 metrics: nil,
                                                                 views: [key: button])
      self.menuBarView.addConstraints(verticalConstraints)

      buttons.updateValue(button, forKey: key)
      if index == 0 {
        horizontalVisualFormat = horizontalVisualFormat + "[\(key)]"
      } else {
        horizontalVisualFormat = horizontalVisualFormat + "[\(key)(==\(String(describing: buttons.first!.key)))]"
      }

      index += 1
    }

    let vfString = String(format: "H:|%@|", horizontalVisualFormat)
    let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: vfString,
                                                        options: .alignAllBottom,
                                                             metrics: nil,
                                                             views: buttons)
    self.menuBarView.addConstraints(horizontalConstraints)
  }

  fileprivate func setupContentCollection() {

  }
}

extension SlidingPageTabViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.numberOfPage
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: PageCell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.identifier, for: indexPath) as! PageCell
    let pageInfo :Dictionary = pageInfos[indexPath.row]
    let viewController :UIViewController = pageInfo.first?.value as! UIViewController
    cell.contentView.addSubview(viewController.view)


    viewController.view.translatesAutoresizingMaskIntoConstraints = false

    let views: [String:Any]
    views = ["view": viewController.view]
    let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                               options: .alignAllLeft,
                                                               metrics: nil,
                                                               views: views)
    let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                             options: .alignAllLeft,
                                                             metrics: nil,
                                                             views: views)
    cell.contentView.addConstraints(horizontalConstraints)
    cell.contentView.addConstraints(verticalConstraints)

    self.addChildViewController(viewController)
    return cell
  }
}

extension SlidingPageTabViewController: UICollectionViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.menuUnderLineViewLeftConstraint.constant = scrollView.contentOffset.x/CGFloat(self.numberOfPage)
  }
}

class PageCell: UICollectionViewCell {
  static let identifier = "PageCell"

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
