#  Syntax.rb
#  publish4AllUtilityTools
#
#  Created by ZhuWeicheng on 9/9/15.
#  Copyright (c) 2015 Zhu,Weicheng. All rights reserved.



let urlOfHtml = String(stringInterpolationSegment: NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("index", ofType:"html")!)!)
println(urlOfHtml)
let input = system("open " + urlOfHtml )