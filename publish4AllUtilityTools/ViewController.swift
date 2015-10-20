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
    
    //printer Info
    var webContentDetails = ""
    var printerPageCount = 0
    var totalPagePrint = 0
    var totalColorPage = 0
    var totalJams = 0
    var totalMissPicks = 0
    var returnFinalValue = 0;
    var printerName = "";
    var PrinterIp = "";
    
    
    
    
    
    
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
         self.tableView.reloadData()
    }
    
    
    
    // webview override functions
    
    func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
        self.webView.stringByEvaluatingJavaScriptFromString("param = 'sinet'")
        self.webView.stringByEvaluatingJavaScriptFromString("running()")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "WebKitDeveloperExtras")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        webView.policyDelegate = self;
        webView.frameLoadDelegate = self;
        webView.UIDelegate = self;
        webView.editingDelegate = self;
        printerDataArray()
        print(printerDataAarry)
        
        webResponce()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList:", name:"refreshMyTableView", object: nil) 
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
    }
    
   // tableView functions
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        let companies = realm.objects(PrinterInfoData)
        return companies.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let companies = realm.objects(PrinterInfoData)
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier("cell", owner: self) as! NSTableCellView
        cellView.textField!.stringValue = companies[row].name
        if isHostConnected("http://\(companies[row].ip)") == false {
            cellView.imageView!.image  = NSImage(named: "cross")
            return cellView
        } else if isHostConnected("http://\(companies[row].ip)/DevMgmt/ProductUsageDyn.xml") == true {
            cellView.imageView!.image  = NSImage(named: "printer")
            return cellView
        }
        else    {
            cellView.imageView!.image  = NSImage(named: "web_connected")
            return cellView
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if (self.tableView.numberOfSelectedRows > 0)
        {
            let companies = realm.objects(PrinterInfoData)
            let selectedItemIp = companies[self.tableView.selectedRow].ip
            ipAdress = selectedItemIp
            self.deletingObjectIp = ipAdress
            webResponceOnClick()
            
        }
    }
    // tableview adding button data reload.
    func refreshList(notification: NSNotification){
        tableView.reloadData()
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
        if let _ = NSURL(string: ipRequestAddress) {
            if isHostConnected(ipRequestAddress) {
                webResponce();
                xmlInformationToJsValue()
            }
            else {
                webResponce404();
            }
        }
        else {
            webResponce404();
        }
    }
    
    // connection checking

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
    
    func webInformationGrabStep(paramUrl: String, firstArgument: String, secondArgument: String) -> Int {
        let ipRequestAddress = "http://\(paramUrl)/"
        let xmlInformation = ipRequestAddress + "DevMgmt/ProductUsageDyn.xml"
        if isHostConnected(xmlInformation) {
        let url = NSURL(string: xmlInformation)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            let webContent = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let printerPageArray = webContent!.componentsSeparatedByString(firstArgument)
            if printerPageArray.count > 1 {
                
                let printerPageArray = printerPageArray[1].componentsSeparatedByString(secondArgument)
                
                if printerPageArray.count > 1 {
                    
                    
                    let printerLocalPageCount = printerPageArray[0]
                        if let returnValue = Int(printerLocalPageCount) {
                            self.returnFinalValue = returnValue
                            print(firstArgument)
                            print(returnValue)
                        }
                }
            }
            

        })
        task.resume()
            return returnFinalValue
        }
        else {
        return 0
        }
    }
    
    func xmlInformationToJsValue() {
        self.printerPageCount = webInformationGrabStep(ipAdress, firstArgument: "<dd:TotalImpressions PEID=\"5082\">", secondArgument: "</dd:TotalImpressions>")
        self.totalPagePrint = webInformationGrabStep(ipAdress, firstArgument: "<dd:TotalImpressions>", secondArgument: "</dd:TotalImpressions>")
        self.totalColorPage = webInformationGrabStep(ipAdress, firstArgument: "<dd:ColorImpressions>", secondArgument: "</dd:ColorImpressions>")
        self.totalJams = webInformationGrabStep(ipAdress, firstArgument: "<dd:JamEvents PEID=\"16076\">", secondArgument: "</dd:JamEvents>")
        self.totalMissPicks = webInformationGrabStep(ipAdress, firstArgument: "<dd:MispickEvents>", secondArgument: "</dd:MispickEvents>")
    }
    
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        if(message.name == "callbackHandler") {
            print("JavaScript is sending a message \(message.body)")
        }
    }
}

