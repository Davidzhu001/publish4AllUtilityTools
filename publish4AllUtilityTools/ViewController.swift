//
//  ViewController.swift
//  publish4AllUtilityTools
//
//  Created by ZhuWeicheng on 9/4/15.
//  Copyright (c) 2015 Zhu,Weicheng. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {

    @IBOutlet weak var webViewer: WebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        var try6 = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("index", ofType:"html")!)
        let fragUrl = NSURL(string: "index.html", relativeToURL: try6)!
        let request = NSURLRequest(URL: fragUrl)
        self.webViewer.mainFrame.loadRequest(request)
        println(request)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    


}

