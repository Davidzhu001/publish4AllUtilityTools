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
    let realm = try! Realm()
    @IBAction func reducingPrinter(sender: AnyObject) {
        self.tableView.reloadData()

        
    }
    @IBAction func addingButton(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    
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
        
        self.tableView.reloadData()
    }
    

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    
    
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        let companies = realm.objects(PrinterInfoData)
        return companies.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let companies = realm.objects(PrinterInfoData)
        let cellView = tableView.makeViewWithIdentifier("cell", owner: self) as! NSTableCellView
        cellView.textField!.stringValue = companies[row].name
        
        return cellView
     }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if (self.tableView.numberOfSelectedRows > 0)
        {
            let companies = realm.objects(PrinterInfoData)
            let selectedItemIp = companies[self.tableView.selectedRow].ip
            
            print(selectedItemIp, terminator: "")
            webResponce2()
            
//            self.tableView.deselectRow(self.tableView.selectedRow)
        }
    }
    
}

