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





# ruby validation of a url
require 'net/http'

def working_url?(url_str)
    url = URI.parse(url_str)
    Net::HTTP.start(url.host, url.port) do |http|
        http.head(url.request_uri).code == '200'
        p "true"
    end
    rescue
    false
    p "something"
end
working_url?("http://google",)
