//
//  ViewController.swift
//  WSTabViewControlSwift
//
//  Created by WebsoftProfession on 04/12/2023.
//  Copyright (c) 2023 WebsoftProfession. All rights reserved.
//

import UIKit
import WSTabViewControlSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tabViewControl: WSTabView!
    @IBOutlet weak var resultLabel: UILabel!

    var options: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        options = ["Cricket","Football","Hockey","More More More More More","Hockey","Hockey","Hockey"]
        tabViewControl.delegate = self;
        
        // normal style configurations
//        tabViewControl.tabControlStyle = .normal
//        tabViewControl.interItemSpacing = 10
//        tabViewControl.isFixedWidth = false
//        tabViewControl.activeTitleColor = .white
//        tabViewControl.activeBackcroundColor = .orange
        
        
        // borderStyle configurations
//        tabViewControl.tabControlStyle = .borderStyle
//        tabViewControl.interItemSpacing = 5
//        tabViewControl.borderRadius = 8
//        tabViewControl.activeTitleColor = .orange
//        tabViewControl.activeBackcroundColor = .white
        
        
        // lineStyle configurations
        tabViewControl.tabControlStyle = .lineStyle
        tabViewControl.isFixedWidth = false
        tabViewControl.interItemSpacing = 5
        tabViewControl.activeTitleColor = .orange
        tabViewControl.activeBackcroundColor = .white
        

        tabViewControl.setupTabView()
        
        
        
        //wsTabView.activeBackcroundColor = [UIColor greenColor];
        //wsTabView.activeTitleColor = [UIColor redColor];
        //wsTabView.inActiveBackgroundColor = [UIColor greenColor];
    }
    
    @IBAction func scrollAction(_ sender: Any) {
        tabViewControl.scrollTabAt(index: 3)
    }
    
}

extension ViewController: WSTabViewDelegate {
    
    func titleForTabAt(index: Int) -> String {
        options[index]
    }
    
    func numberOfTabs() -> Int {
        options.count
    }
    
    func didSelectTabAt(index: Int) {
        resultLabel.text = options[index]
    }
}



