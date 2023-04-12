//
//  WSTabView.swift
//  WSTabViewControlSwift
//
//  Created by WebsoftProfession on 11/04/23.
//

import UIKit

public protocol WSTabViewDelegate {
    func titleForTabAt(index: Int) -> String
    func numberOfTabs() -> Int
    func didSelectTabAt(index: Int)
}

extension WSTabViewDelegate {
    func didSelectTabAt(index: Int) {
        
    }
    
}

public enum TabStyle {
    case normal
    case lineStyle
    case borderStyle
}

public class WSTabView: UIView {

    var scrollView: UIScrollView?
    var currentTab: WSTabButton?
    
    public var delegate: WSTabViewDelegate?
    
    public var activeBackcroundColor: UIColor = .orange
    public var inActiveBackgroundColor: UIColor = .white
    public var activeTitleColor: UIColor = .white
    public var inActiveTitleColor: UIColor = .black
    public var tabFont: UIFont?
    
    public var tabControlStyle: TabStyle = .normal
    public var interItemSpacing: Int = 0
    public var borderRadius: Double = 0.0
    public var lineColor: UIColor?
    public var isFixedWidth: Bool = true
    public var minimumTabWidth: CGFloat = 100
    
    private var previousIndex: Int = 0
    
    private var bottomLine: UIView?
    
    public func setupTabView(){
        
        var currentTabFrame: CGRect = .zero
        
        if (scrollView == nil) {
            scrollView = UIScrollView()
            scrollView?.backgroundColor = .clear
            scrollView?.showsHorizontalScrollIndicator = false
            self.addSubview(scrollView!)
            scrollView?.frame=CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height);
        }
        else
        {
            scrollView?.subviews.forEach { $0.removeFromSuperview() }
        }
        
        let count = self.delegate?.numberOfTabs() ?? 0
        var previousTabX = 0
        var itemWidth = 100.0
        for i in 0..<count {
            
            let title = self.delegate?.titleForTabAt(index: i) ??  ""
            
            if !isFixedWidth {
                itemWidth = title.size(withAttributes: [.font: (self.tabFont ?? UIFont.init(name: "Arial", size: 12))!]).width
                itemWidth = itemWidth < minimumTabWidth ? minimumTabWidth : (itemWidth + 10)
            }
            
            let tab = WSTabButton.init(type: .custom)
            tab.frame = CGRect(x: previousTabX + interItemSpacing, y: 5, width: Int(itemWidth + 10), height: Int(self.frame.size.height) - 10);
            previousTabX = Int(tab.frame.origin.x + tab.frame.size.width)
            tab.titleLabel?.lineBreakMode = .byWordWrapping
            tab.titleLabel?.textAlignment = .center;
            
            tab.titleLabel?.font = self.tabFont ?? UIFont.init(name: "Arial", size: 12)
            tab.setTitle(title, for: .normal)
            
            
            
            tab.titleLabel?.textColor = self.inActiveTitleColor
            tab.setTitleColor(self.inActiveTitleColor, for: .normal)
            
            tab.backgroundColor = self.inActiveBackgroundColor
            scrollView?.addSubview(tab)
            
            if self.tabControlStyle == .borderStyle {
                tab.layer.borderWidth = 1.0
                tab.layer.borderColor = self.inActiveTitleColor.cgColor
                tab.layer.cornerRadius = borderRadius
            }
            
            tab.index = i;
            tab.addTarget(self, action: #selector(tabClickAction(tab:)), for: .touchUpInside)

            if currentTab == nil {
                currentTab = tab
            }
            
            if currentTab?.index == i {
                tab.isActive = true
                currentTab = tab
                currentTabFrame = tab.frame
                self.delegate?.didSelectTabAt(index: i)
            }
            
            if tab.isActive {
                tab.setTitleColor(self.activeTitleColor, for: .normal)
                tab.titleLabel?.textColor = self.inActiveTitleColor
                tab.backgroundColor = self.activeBackcroundColor
                if self.tabControlStyle == .borderStyle {
                    tab.layer.borderColor = self.activeTitleColor.cgColor
                }
                else if self.tabControlStyle == .lineStyle {
                    if self.bottomLine == nil {
                        self.bottomLine = UIView(frame: CGRect(x: tab.frame.origin.x, y: tab.frame.origin.y + tab.frame.size.height - 2, width: tab.frame.size.width, height: 2))
                    }
                    self.bottomLine?.backgroundColor = self.lineColor ??  self.activeTitleColor
                    self.scrollView?.addSubview(self.bottomLine!)
                    self.runLineAnimation(to: tab)
                    
                }
            }
            
            if i == (count - 1) {
                
                scrollView?.contentSize = CGSize(width: tab.frame.origin.x + tab.frame.size.width + (isFixedWidth ? 35 : 30), height: self.frame.size.height)
                
                if previousIndex > currentTab!.index {
                    scrollView?.scrollRectToVisible(CGRect(x: currentTabFrame.origin.x - 40, y: currentTabFrame.origin.y, width: currentTabFrame.size.width+10, height: currentTabFrame.size.height), animated: true)
                }
                else {
                    scrollView?.scrollRectToVisible(CGRect(x: currentTabFrame.origin.x + 40, y: currentTabFrame.origin.y, width: currentTabFrame.size.width+10, height: currentTabFrame.size.height), animated: true)
                }
                
                previousIndex = currentTab!.index
            }
        }
        
    }
    
    @objc func tabClickAction(tab: WSTabButton) {
        tab.isActive=true;
        currentTab=tab;
        self.setupTabView()
        self.delegate?.didSelectTabAt(index: tab.index)
    }
    
    func runLineAnimation(to tab: WSTabButton){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.bottomLine?.frame = CGRect(x: tab.frame.origin.x, y: (self.bottomLine?.frame.origin.y)!, width: tab.frame.size.width, height: (self.bottomLine?.frame.size.height)!)
        })
    }
    
    public func scrollTabAt(index: Int) {
        self.scrollView?.subviews.forEach({
            if let tab = $0 as? WSTabButton {
                if tab.index == index {
                    if previousIndex > index {
                        self.scrollView?.scrollRectToVisible(CGRect(x: tab.frame.origin.x - 40, y: tab.frame.origin.y, width: tab.frame.size.width+10, height: tab.frame.size.height), animated: true)
                    }
                    else {
                        self.scrollView?.scrollRectToVisible(CGRect(x: tab.frame.origin.x + 40, y: tab.frame.origin.y, width: tab.frame.size.width+10, height: tab.frame.size.height), animated: true)
                    }
                    self.scrollView?.bringSubviewToFront(self.bottomLine!)
                    self.runLineAnimation(to: tab)
                    self.delegate?.didSelectTabAt(index: index)
                    
                }
            }
        })
    }
    

}
