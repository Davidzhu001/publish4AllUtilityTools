//
//  ViewController.swift
//  publish4AllUtilityTools
//
//  Created by ZhuWeicheng on 9/4/15.
//  Copyright (c) 2015 Zhu,Weicheng. All rights reserved.
//

import Cocoa
import WebKit
import Realm
import Foundation
import RealmSwift

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    

    @IBOutlet weak var webViewer: WebView!
    @IBOutlet weak var tableView: NSTableView!
    var objects:NSMutableArray! = NSMutableArray()
    let realm = try! Realm()
    
    
    func webResponce() {
        let try6 = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("index", ofType:"html")!)
        let fragUrl = NSURL(string: "index.html", relativeToURL: try6)!
        let request = NSURLRequest(URL: fragUrl)
        self.webViewer.mainFrame.loadRequest(request)
    };
    
    func webResponce2() {
        let url = NSURL(string: "http://192.168.2.102/")
        let request = NSURLRequest(URL: url!);
        self.webViewer.mainFrame.loadRequest(request);
        
        
        // (1) Create a Dog object and then set its properties
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webResponce()
        
        // table
        for index in 1...5 {
            print("\(index) times 5 is \(index * 5)", terminator: "")
            self.objects.addObject("\(index)")
        }
        self.objects.addObject("192.168.2.102")
        self.tableView.reloadData()
        let myDog = PrinterInfoData()
        myDog.name = "Rex"
        myDog.ip = "10"
        realm.write {
            self.realm.add(myDog)
        }
    }
    

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    
    
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return self.objects.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
      let cellView = tableView.makeViewWithIdentifier("cell", owner: self) as! NSTableCellView
        cellView.textField!.stringValue = self.objects.objectAtIndex(row) as! String
        
        return cellView
     }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if (self.tableView.numberOfSelectedRows > 0)
        {
            let selectedItem = self.objects.objectAtIndex(self.tableView.selectedRow) as! String
            
            print(selectedItem, terminator: "")
            webResponce2()
//            self.tableView.deselectRow(self.tableView.selectedRow)  
        }
    }
    
    
    
    // realm data
    
    
}

