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
    @IBAction func addingPrinter(sender: AnyObject) {
        let myDog = PrinterInfoData()
        myDog.name = "some"
        myDog.ip = "10"
        let realm = try! Realm()
        realm.write {
            realm.add(myDog)
            print("ss")
        }
        self.view.window?.close()
        }
}
