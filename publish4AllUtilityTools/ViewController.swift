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
    
    var ipAdress = "192.168.2.102"
    var deletingObjectIp = ""

    @IBOutlet weak var webViewer: WebView!
    @IBOutlet weak var tableView: NSTableView!
    let realm = try! Realm()
    @IBAction func reducingPrinter(sender: AnyObject) {
        
        let objectPrinter = realm.objects(PrinterInfoData).filter("ip = '\(deletingObjectIp)'")
            realm.write {
                self.realm.delete(objectPrinter)
            }
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
    
    func webResponce404() {
        let try6 = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("404", ofType:"html")!)
        let fragUrl = NSURL(string: "404.html", relativeToURL: try6)!
        let request = NSURLRequest(URL: fragUrl)
        self.webViewer.mainFrame.loadRequest(request)
    };
    
    func webResponceOnClick() {
        let ipRequestAddress = "http://\(ipAdress)/"
        isHostConnected(ipRequestAddress)
        let url = NSURL(string: ipRequestAddress)
        let request = NSURLRequest(URL: url!);
        
        if isHostConnected(ipRequestAddress) {
            self.webViewer.mainFrame.loadRequest(request);
            print("good connection")
        }
        else {
            webResponce404();
            print("no connection")
        }

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webResponce()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
    }
    

    override var representedObject: AnyObject? {
        didSet {
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
            ipAdress = selectedItemIp
            print(ipAdress)
            self.deletingObjectIp = ipAdress
            
//            let deletingObjects = PrinterInfoData()
//            deletingObjects.ip = companies[self.tableView.selectedRow].ip
//            deletingObjects.name = companies[self.tableView.selectedRow].name
//            self.deletingObject = deletingObjects
            webResponceOnClick()
            
//            self.tableView.deselectRow(self.tableView.selectedRow)
        }
    }
    func isHostConnected(hostAddress : String) -> Bool
    {
        let request = NSMutableURLRequest(URL: NSURL(string: hostAddress.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
        request.timeoutInterval = 1
        request.HTTPMethod = "HEAD"
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var responseCode = -1
        
        let group = dispatch_group_create()
        dispatch_group_enter(group)
        
        session.dataTaskWithRequest(request, completionHandler: {(_, response, _) in
            if let httpResponse = response as? NSHTTPURLResponse {
                responseCode = httpResponse.statusCode
            }
            dispatch_group_leave(group)
        }).resume()
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        return (responseCode == 200)
    }
    func loadList(notification: NSNotification){
        self.tableView.reloadData()
    }
    
}

