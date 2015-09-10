require 'rexml/document'
require 'open-uri'
include REXML

document_file = open("http://192.168.2.102/DevMgmt/ProductUsageDyn.xml"){ |f| f.read }
xmlfile = File.new(document_file)
xmldoc = Document.new(xmlfile)
print "#{document_file}"
# Now get the root element
root = xmldoc.root
