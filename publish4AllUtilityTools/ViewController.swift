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
    var printerIp = "";
    
    
    
    var deletingObjectIp = "";
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
        xmlInformationToJsValue()
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            print("1234234")
            self.webView.stringByEvaluatingJavaScriptFromString("printerPageCount = \"\(self.printerPageCount)\"")
            self.webView.stringByEvaluatingJavaScriptFromString("webContentDetails = \"\(self.webContentDetails)\"")
            self.webView.stringByEvaluatingJavaScriptFromString("totalPagePrint = \"\(self.totalPagePrint)\"")
            self.webView.stringByEvaluatingJavaScriptFromString("totalColorPage = \"\(self.totalColorPage)\"")
            self.webView.stringByEvaluatingJavaScriptFromString("totalJams = \"\(self.totalJams)\"")
            self.webView.stringByEvaluatingJavaScriptFromString("totalMissPicks = \"\(self.totalMissPicks)\"")
            self.webView.stringByEvaluatingJavaScriptFromString("printerName = \"\(self.printerName)\"")
            self.webView.stringByEvaluatingJavaScriptFromString("printerIp = \"\(self.printerIp)\"")
            self.webView.stringByEvaluatingJavaScriptFromString("running()")
            print(self.printerPageCount)
        })
    }
    override func viewWillAppear() {
        
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList:", name:"refreshMyTableView", object: nil)
        webResponce()
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
            let selectedItemName = companies[self.tableView.selectedRow].ip
            self.printerIp = selectedItemIp
            self.printerName = selectedItemName
            self.deletingObjectIp = printerIp
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
        xmlInformationToJsValue()
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
        let ipRequestAddress = "http://\(printerIp)/"
        if let _ = NSURL(string: ipRequestAddress) {
            if isHostConnected(ipRequestAddress) {
                webResponce();
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
        request.timeoutInterval = 3
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
    
    
    func webInformationGrabStep(paramUrl: String, firstArgument: String, secondArgument: String, thirdArgument: String){
        let ipRequestAddress = "http://\(paramUrl)/"
        var localreturnFinalValue = 0
        let xmlInformation = ipRequestAddress + "DevMgmt/ProductUsageDyn.xml"
        let url = NSURL(string: xmlInformation)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let webContent = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                let printerPageArray = webContent.componentsSeparatedByString(firstArgument)
                if printerPageArray.count > 1 {
                    
                    let printerPageArray = printerPageArray[1].componentsSeparatedByString(secondArgument)
                    
                    if printerPageArray.count > 1 {
                        
                        
                        let printerLocalPageCount = printerPageArray[0]
                        if let returnValue = Int(printerLocalPageCount) {
                            localreturnFinalValue = returnValue
                            switch thirdArgument {
                            case "printerPageCount":
                                self.printerPageCount = localreturnFinalValue
                                print(localreturnFinalValue)
                            case "totalPagePrint":
                                self.totalPagePrint = localreturnFinalValue
                                print(localreturnFinalValue)
                            case "totalColorPage":
                                self.totalColorPage = localreturnFinalValue
                                print(localreturnFinalValue)
                            case "totalJams":
                                self.totalJams = localreturnFinalValue
                                print(localreturnFinalValue)
                            case "totalMissPicks":
                                self.totalMissPicks = localreturnFinalValue
                                print(localreturnFinalValue)
                            default:
                                print("misstake")
                            }
                        }
                    }
                }
            }
            
        })
        task.resume()
        print("misstake")
    }
    
    func xmlInformationToJsValue() {
        webInformationGrabStep(printerIp, firstArgument: "<dd:TotalImpressions PEID=\"5082\">", secondArgument: "</dd:TotalImpressions>", thirdArgument: "printerPageCount")
        webInformationGrabStep(printerIp, firstArgument: "<dd:TotalImpressions>", secondArgument: "</dd:TotalImpressions>", thirdArgument: "totalPagePrint")
        webInformationGrabStep(printerIp, firstArgument: "<dd:ColorImpressions>", secondArgument: "</dd:ColorImpressions>", thirdArgument: "totalColorPage")
        webInformationGrabStep(printerIp, firstArgument: "<dd:JamEvents PEID=\"16076\">", secondArgument: "</dd:JamEvents>", thirdArgument: "totalJams")
        webInformationGrabStep(printerIp, firstArgument: "<dd:MispickEvents>", secondArgument: "</dd:MispickEvents>", thirdArgument: "totalMissPicks")
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        if(message.name == "callbackHandler") {
            print("JavaScript is sending a message \(message.body)")
        }
    }
}

