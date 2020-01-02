require "sinatra"
require "pstore"

get("/register") do
	erb :register
end
post("/register") do
if File.exist?("#{params["phone"]}.pstore")
	"Error"
else
	store = PStore.new("#{params['phone']}.pstore")
	store.transaction do
	store["items"] = {"items" => 0}
		store.commit
	end
	store = PStore.new("users.pstore")
	store.transaction do
	store["#{params['phone']}"] = {"phone" => params["phone"], "password" => params["pass"]}
		store.commit
	end
	"Registered!"
end
end
get("/myreceipts") do
erb :login
end
post("/myreceipts") do
store = PStore.new("users.pstore")
if store.transaction {store["#{params['phone']}"]}["password"] == params["pass"]
@phone = params["phone"]
erb :myreceipts
else
"Invalid Login"
end
end
get("/") do
erb :home
end






