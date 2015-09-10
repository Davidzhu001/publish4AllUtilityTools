//: Playground - noun: a place where people can play

import Cocoa


let filemgr = NSFileManager.defaultManager()
let currentPath = filemgr.currentDirectoryPath
let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
    .UserDomainMask, true)

let docsDir = dirPaths[0] as! String

let tmpDir = NSTemporaryDirectory() as String