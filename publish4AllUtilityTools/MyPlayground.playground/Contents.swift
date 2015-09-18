////: Playground - noun: a place where people can play
//
//import Cocoa
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

struct Number
{
    var digits: Int
    let numbers = 3.1415
}

var n = Number(digits: 12345)
n.digits = 67

print("\(n.digits)")
print("\(n.numbers)")
n.numbers