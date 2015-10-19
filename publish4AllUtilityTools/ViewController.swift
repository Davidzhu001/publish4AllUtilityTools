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

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, WKScriptMessageHandler, WebPolicyDelegate, WebFrameLoadDelegate, WebUIDelegate  {
    
    
    // variables handling the information of the
    var totalConnectedPrinters = 0
    var totalUnconnectedPrinters = 0
    var totalPrinter = 0
    var webContentDetails = ""
    var printerPageCount = 0
    var ipAdress = ""
    var deletingObjectIp = ""
    let realm = try! Realm()
    var arrayOfDicts : NSMutableArray?
    
    var printerDataAarry = [Dictionary<String,String>]()
    // outlets
    @IBOutlet weak var connectedPrinterNumberLabel: NSTextField!
    @IBOutlet weak var unconnectedPrinterNumberLabel: NSTextField!
    @IBOutlet weak var webView: WebView!
    
    @IBOutlet weak var tableView: NSTableView!
    @IBAction func reloadData(sender: AnyObject) {
        self.tableView.reloadData()
        printerDataArray()
        print(printerDataAarry.last)
        
    }
    @IBAction func reducingPrinter(sender: AnyObject) {
        
        let objectPrinter = realm.objects(PrinterInfoData).filter("ip = '\(deletingObjectIp)'")
            realm.write {
                self.realm.delete(objectPrinter)
            }
        self.tableView.reloadData()
    }
    @IBAction func addingButton(sender: AnyObject) {
    }
    
    
    
    // webview override functions
    
    func webView(webView: WKWebView!, decidePolicyForNavigationAction navigationAction: WKNavigationAction!, decisionHandler: ((WKNavigationActionPolicy) -> Void)!) {
        if (navigationAction.navigationType == WKNavigationType.LinkActivated && !navigationAction.request.URL!.host!.lowercaseString.hasPrefix("www.appcoda.com/")) {
            print("something")
        } else {
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(printerDataAarry)
        webView.policyDelegate = self;
        webView.frameLoadDelegate = self;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)

        
        
        let try6 = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("index", ofType:"html")!)
        let task = NSURLSession.sharedSession().dataTaskWithURL(try6, completionHandler: { (data, response, error) -> Void in
            let webContent = NSString(data: data!, encoding: NSUTF8StringEncoding)
            self.webContentDetails = webContent! as String
            print("111111")
            
        })
        task.resume()
        localWebResponces();
        
        
        // Do any additional setup after loading the view.
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "WebKitDeveloperExtras")
        NSUserDefaults.standardUserDefaults().synchronize()
        printerDataArray()
        print(printerDataAarry)

    }
    
    
    func printerDataArray() {
        let printerDatas = realm.objects(PrinterInfoData)
        var index = 0;
       while index < printerDatas.count {
        if index == 0 {
            printerDataAarry = []
        }
        let newData = ["Ip": String("\(printerDatas[index].ip)"), "name": String("\(printerDatas[index].name)")]
        self.printerDataAarry.append(newData)
        index++
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        }
    }
    
    override func viewDidAppear() {
        unconnectedPrinterNumberLabel.stringValue = "\(totalUnconnectedPrinters)"
        connectedPrinterNumberLabel.stringValue = "\(totalConnectedPrinters)"
    }
    
   // tableView functions
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        let companies = realm.objects(PrinterInfoData)
        if companies.count == 0 {
            totalConnectedPrinters = 0
            totalUnconnectedPrinters = 0
        }
        return companies.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let companies = realm.objects(PrinterInfoData)
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier("cell", owner: self) as! NSTableCellView
        cellView.textField!.stringValue = companies[row].name
        if row == 0 {
             totalConnectedPrinters = 0
             totalUnconnectedPrinters = 0
        }
        if isHostConnected("http://\(companies[row].ip)") == false {
            cellView.imageView!.image  = NSImage(named: "cross")
            totalUnconnectedPrinters++
            return cellView
        } else if isHostConnected("http://\(companies[row].ip)/DevMgmt/ProductUsageDyn.xml") == true {
            cellView.imageView!.image  = NSImage(named: "printer")
            totalConnectedPrinters++
            return cellView
        }
        else    {
            cellView.imageView!.image  = NSImage(named: "web_connected")
            totalConnectedPrinters++
            return cellView
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if (self.tableView.numberOfSelectedRows > 0)
        {
            let companies = realm.objects(PrinterInfoData)
            let selectedItemIp = companies[self.tableView.selectedRow].ip
            ipAdress = selectedItemIp
            print(ipAdress)
            self.deletingObjectIp = ipAdress
            webResponceOnClick()
            
        }
    }
    
    func localWebResponces(){
        let htmlUrl = self.webContentDetails
        
        self.webView.mainFrame.loadHTMLString(htmlUrl, baseURL: nil)

    }

    
    
    // webview supporting functions

    
    
    
    func webResponce() {
        let try6 = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("index", ofType:"html")!)
        let fragUrl = NSURL(string: "index.html", relativeToURL: try6)!
        let request = NSURLRequest(URL: fragUrl)
        self.webView.mainFrame.loadRequest(request)
    };
    
    func webResponce404() {
        let try6 = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("404", ofType:"html")!)
        let fragUrl = NSURL(string: "404.html", relativeToURL: try6)!
        let request = NSURLRequest(URL: fragUrl)
        self.webView.mainFrame.loadRequest(request)
    };
    
    func webResponceOnClick() {
        let ipRequestAddress = "http://\(ipAdress)/"
        isHostConnected(ipRequestAddress)
        if let url = NSURL(string: ipRequestAddress) {
            let request = NSURLRequest(URL: url)
            if isHostConnected(ipRequestAddress) {
                    self.webView.mainFrame.loadRequest(request);
                    webInformationGrabStep(ipRequestAddress)
                }
        }
        else {
            webResponce404();
        }
    }

    func isHostConnected(hostAddress : String) -> Bool
    {
        let request = NSMutableURLRequest(URL: NSURL(string: hostAddress.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
        request.timeoutInterval = 0.3
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
    
    func labelReload() {
        tableView.reloadData()
    }
    
    
    
    func webInformationGrabStep(paramUrl: String) {
        let xmlInformation = paramUrl + "DevMgmt/ProductUsageDyn.xml"
        if isHostConnected(xmlInformation) {
        let url = NSURL(string: xmlInformation)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            let webContent = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let printerPageArray = webContent!.componentsSeparatedByString("<dd:TotalImpressions PEID=\"5082\">")
            if printerPageArray.count > 1 {
                
                print(printerPageArray.count)
                
                let printerPageArray = printerPageArray[1].componentsSeparatedByString("</dd:TotalImpressions>")
                
                if printerPageArray.count > 1 {
                    
                    
                    let printerLocalPageCount = printerPageArray[0]
                    
                    self.printerPageCount = Int(printerLocalPageCount)!
                    print(printerLocalPageCount)
                    
                }
            }
            

        })
        task.resume()
        }
        else {
        print("no information")
        }
    }
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        if(message.name == "callbackHandler") {
            print("JavaScript is sending a message \(message.body)")
        }
    }
    
}

