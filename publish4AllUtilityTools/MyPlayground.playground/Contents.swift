//: Playground - noun: a place where people can play

import Cocoa


import Foundation

let task = NSTask()
task.launchPath = "/usr/bin/osascript"
task.arguments = ["~/Desktop/appdownloading.scpt"]

task.launch()


func executeCommand(command: String, args: [String]) -> String {
    
    let task = NSTask()
    
    task.launchPath = command
    task.arguments = args
    
    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
    
    return output
}
let commandOutput = executeCommand("lpstat", [" -W all"])
println("Command output: \(commandOutput)")
