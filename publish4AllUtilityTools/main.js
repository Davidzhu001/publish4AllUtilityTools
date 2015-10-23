var printerPageCount;
var totalPagePrint;
var totalColorPage;
var totalJams;
var totalMissPicks;
var printerName;
var printerIp;

function running() {
    document.getElementById('printerPageCount').innerHTML = printerPageCount
    document.getElementById('totalPagePrint').innerHTML = totalPagePrint
    document.getElementById('totalColorPage').innerHTML = totalColorPage
    document.getElementById('totalJams').innerHTML = totalJams
    document.getElementById('totalMissPicks').innerHTML = totalMissPicks
    document.getElementById('printerName').innerHTML = printerName
    document.getElementById('PrinterIp').innerHTML = PrinterIp
    console.log(printerPageCount)
    console.log(totalPagePrint)
    console.log(totalColorPage)
    console.log(totalJams)
    console.log(printerIp)
};
// Wait for window load
$(window).load(function() {
               $(".se-pre-con").fadeOut(2000);
               });