require 'rexml/document'
require 'open-uri'
require 'json'
include REXML
hash =
document_file = open("http://192.168.2.102/DevMgmt/ProductUsageDyn.xml"){ |f| f.read }
something = Hash.from_xml(document_file).to_json
xmlfile = File.new(document_file)
xmldoc = Document.new(xmlfile)
print "#{document_file}"
# Now get the root element
root = xmldoc.root
