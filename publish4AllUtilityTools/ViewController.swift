//
//  ViewController.swift
//  publish4AllUtilityTools
//
//  Created by ZhuWeicheng on 9/4/15.
//  Copyright (c) 2015 Zhu,Weicheng. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var webViewer: WebView!
    @IBOutlet weak var tableView: NSTableView!
    var objects:NSMutableArray! = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        var try6 = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("index", ofType:"html")!)
        let fragUrl = NSURL(string: "index.html", relativeToURL: try6)!
        let request = NSURLRequest(URL: fragUrl)
        self.webViewer.mainFrame.loadRequest(request)
        
        // table
        
        self.objects.addObject("something")
        self.objects.addObject("something")
        self.objects.addObject("something")
        
        self.tableView.reloadData()
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
      var cellView = tableView.makeViewWithIdentifier("cell", owner: self) as! NSTableCellView
        cellView.textField!.stringValue = self.objects.objectAtIndex(row) as! String
        
        return cellView
     }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if (self.tableView.numberOfSelectedRows > 0)
        {
            let selectedItem = self.objects.objectAtIndex(self.tableView.selectedRow) as! String
            
            println(selectedItem)
            
//            self.tableView.deselectRow(self.tableView.selectedRow)
        }
    }
}

