//
//  AddingPrinter.swift
//  publish4AllUtilityTools
//
//  Created by ZhuWeicheng on 9/23/15.
//  Copyright © 2015 Zhu,Weicheng. All rights reserved.
//

import Cocoa
import Realm
import Foundation
import RealmSwift

class AddingPrinter: NSViewController {

    @IBOutlet weak var printerIp: NSTextField!
    @IBOutlet weak var printerName: NSTextField!
    @IBOutlet weak var warningLabel: NSTextField!
    @IBAction func addingPrinter(sender: AnyObject) {
        if printerName.stringValue == "" || printerIp.stringValue == "" {
            print("no")
            warningLabel.stringValue = "Please check no empty field."
        } else {
        let addingPrinterForm = PrinterInfoData()
        addingPrinterForm.name = printerName.stringValue
        addingPrinterForm.ip = printerIp.stringValue
        let realm = try! Realm()
        realm.write {
            realm.add(addingPrinterForm)
            }
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        self.view.window?.close()
        }
        }
}