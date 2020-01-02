require "sinatra"
require 'pstore'
before do
  headers "Content-Type" => "text/xml; charset=utf-8"
end
get("/") do
"<Response>
</Response>"
end
post("/") do
ok = true
data = params['Body'].split("\n")
if data.length == 2
	
else
	ok = false
end
if ok
data[1] = data[1].gsub("$", "")
data[1].to_i rescue ok = false
if data[1].to_f == 0.0
ok = false
end
if ok
data[1] = "$" + data[1]
end
end
if params['NumMedia'] == 0
	media = nil
else
	media = params['MediaUrl0']
end
def save(thing, price, media)
		store = PStore.new("#{params['From']}.pstore")
		items = store.transaction {store["items"]["items"]}
	store.transaction do
		store["item#{items+1}"] = {"thing" => thing, "price" => price, "media" => media}
		store["items"] = {"items" => items+1}
		store.commit
	#Use this to read:
	#store.transaction {store["params"]}
		end
	return nil
end
if ok
	"<Response>
	<Message>
	Saved!
	#{data[0]}
	#{data[1]}
	#{media}
	#{if params['NumMedia'].to_i > 1
		"
		Warning - All images except the first one are ignored."
	end}
#{save(data[0], data[1], media) unless !File.exist?("#{params['From']}.pstore")}
	</Message>
	</Response>"
else
	"<Response>
	<Message>
	Error

	Correct format example:

	McDonalds
	7.99

	Image is optional
	Push return or enter between store and price
	0 is not accepted as a price.
	</Message>
	</Response>"
end
end