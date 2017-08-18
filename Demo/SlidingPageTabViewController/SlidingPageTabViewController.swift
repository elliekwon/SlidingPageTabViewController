//
//  SlidingPageTabViewController.swift
//
//  Copyright © 2017 Ellie Kwon. All rights reserved.
//

import UIKit

class SlidingPageTabViewController: UIViewController {

  var pageInfoDic: Array<Dictionary<String, Any>>! //{
//    didSet {
//      self.numberOfPage = pageInfo.count
//    }
//  }

  fileprivate var numberOfPage = 0

  fileprivate var menuBarView: UIView!
  fileprivate var menuUnderLineView: UIView!
  fileprivate var menuUnderLineViewLeftConstraint: NSLayoutConstraint!

  fileprivate var contentCollectionView: UICollectionView!

  init(_ pageInfo: Array<Dictionary<String, Any>>) {
    super.init(nibName: nil, bundle: nil)

    self.pageInfoDic = pageInfo
    self.numberOfPage = pageInfoDic.count
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
    self.view.addSubview(contentCollectionView)

    menuBarView.translatesAutoresizingMaskIntoConstraints = false
    menuUnderLineView.translatesAutoresizingMaskIntoConstraints = false
    contentCollectionView.translatesAutoresizingMaskIntoConstraints = false

    contentCollectionView.dataSource = self
    contentCollectionView.delegate = self

    let views: [String:Any]
    views = ["menuBarView": menuBarView, "contentCollectionView": contentCollectionView]
    let horizontalConstraintsForMenu = NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuBarView]|",
                                                               options: .alignAllLeft,
                                                               metrics: nil,
                                                               views: views)
    let horizontalConstraintsForContent = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentCollectionView]|",
                                                               options: .alignAllLeft,
                                                               metrics: nil,
                                                               views: views)
    let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[menuBarView(50)][contentCollectionView]|",
                                                               options: .alignAllLeft,
                                                               metrics: nil,
                                                               views: views)
    self.view.addConstraints(horizontalConstraintsForMenu)
    self.view.addConstraints(horizontalConstraintsForContent)
    self.view.addConstraints(verticalConstraints)



    let views2: [String:Any]
    views2 = ["menuUnderLineView": menuUnderLineView]


    self.menuBarView.addSubview(menuUnderLineView)
    let verticalConstraintsForUnderLine = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[menuUnderLineView(3)]|",
                                                         options: .alignAllLeft,
                                                         metrics: nil,
                                                         views: views2)

    let screenSize: CGRect = UIScreen.main.bounds

    menuUnderLineViewLeftConstraint = NSLayoutConstraint.init(item: menuUnderLineView,
                                                              attribute: .left, relatedBy: .equal, toItem: menuBarView,
                                                              attribute: .left, multiplier: 1.0, constant: 0.0)
    let menuUnderLineViewWidthConstraint = NSLayoutConstraint.init(item: menuUnderLineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenSize.width/CGFloat(self.numberOfPage))


    self.menuBarView.addConstraints(verticalConstraintsForUnderLine)
    self.menuBarView.addConstraint(menuUnderLineViewLeftConstraint)
    self.menuBarView.addConstraint(menuUnderLineViewWidthConstraint)

    menuBarView.backgroundColor = UIColor.red
    menuUnderLineView.backgroundColor = UIColor.blue

    //setupMenus()
  }

  fileprivate func setupMenus() {
    //guard numberOfPage > 0, pageInfoDic.count > 0 else {return}

    var index = 0
    var buttons: [String:Any] = [:]
    var horizontalVisualFormat = ""

    for dic in pageInfoDic {
      let menuName = dic.first?.key

      let button = UIButton()
      button.setTitle(menuName, for: .normal)
      button.tag = index
      button.translatesAutoresizingMaskIntoConstraints = false
      self.menuBarView.addSubview(button)

      let key = String(format: "button%d", index)
      let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[\(key)][menuUnderLineView(3)]|",
                                                                 options: .alignAllLeft,
                                                                 metrics: nil,
                                                                 views: [key: button, "menuUnderLineView": menuUnderLineView])
      self.menuBarView.addConstraints(verticalConstraints)

      buttons.updateValue(button, forKey: key)
      if index == 0 {
        horizontalVisualFormat = horizontalVisualFormat + "[\(key)]"
      } else {
        horizontalVisualFormat = horizontalVisualFormat + "[\(key)(==button0)]"
      }


      index += 1
    }

    let string = String(format: "H:|%@|", horizontalVisualFormat)
    let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: string,
                                                             options: .alignAllLeft,
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
    let pageInfo :Dictionary = pageInfoDic[indexPath.row]
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

    self.contentView.backgroundColor = UIColor.init(hue: CGFloat(drand48()), saturation: 1.0, brightness: 1.0, alpha: 1.0)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
