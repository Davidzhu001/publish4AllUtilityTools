////: Playground - noun: a place where people can play
//
import Cocoa
import ifaddrs
//
//var parser = NSXMLParser()
//var posts = NSMutableArray()
//var elements = NSMutableDictionary()
//var element = NSString()
//var title1 = NSMutableString()
//var date = NSMutableString()
//
//func beginParsing()
//{
//    posts = []
//    parser = NSXMLParser(contentsOfURL: (NSURL (fileURLWithPath:"http://images.apple.com/main/rss/hotnews/hotnews.rss")))!
//    parser.delegate = self
//    parser.parse()
//    tbData!.reloadData()
//}
//
//struct Number
//{
//    var digits: Int
//    let numbers = 3.1415
//}
//
//var n = Number(digits: 12345)
//n.digits = 67
//
//print("\(n.digits)", terminator: "")
//print("\(n.numbe
func getWiFiAddress() -> String? {
    var address : String?
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
    if getifaddrs(&ifaddr) == 0 {
        
        // For each interface ...
        for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
            let interface = ptr.memory
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.memory.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                if let name = String.fromCString(interface.ifa_name) where name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var addr = interface.ifa_addr.memory
                    var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.memory.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST)
                    address = String.fromCString(hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
    }
    
    return address
}

    
    if let addr = getWiFiAddress() {
        print(addr)
} else {
    print("No WiFi address")
}
