socket = require("socket")
function mtk(num)
  for i=num,num+164 do
    add_contact("+"..i,".","",ok_cb,false)
  end
  --mtk(num+164)
end

function adds(cb_extra, success, result)
  local m = {}
  for k,v in pairs(result) do
    if #m < tonumber(cb_extra.count) then
      m[v.phone]=v.peer_id
    end
  end
  local file = io.open("add_shod.txt", "a")
  for k,v in pairs(me) do
    block_user("user#id"..v,ok_cb,false)
    channel_invite(cb_extra.channelId,"user#id"..v,ok_cb,false)
    file:write(v.." "..k)
    del_contact("user#id"..v,ok_cb,false)
  end
  file:flush()
  file:close()
end

function delete(cb_extra, success, result)
  for i=1,tonumber(cb_extra.num) do
    for k,v in pairs(result) do
      del_contact("user#id"..v.peer_id,ok_cb,false)
    end
  end
end

local clock = os.clock
function sleep(n)-- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

function get_contact_list_callback (cb_extra, success, result)
  local text = ""
  for k,v in pairs(result) do
    if v.print_name and v.peer_id and v.phone then
      text = text..v.peer_id.." "..v.phone.."\n"
    end
  end
  local file = io.open("contact_list.txt", "w")
  file:write(text)
  file:flush()
  file:close()
  send_document("user#id"..cb_extra.target,"contact_list.txt",ok_cb, false)--.txt format
end

function run(msg,matches)
  if matches[1] == "sendcontact" and is_sudo(msg)then
    phone = matches[2]
    first_name = matches[3]
    last_name = matches[4]
    send_contact(get_receiver(msg), phone, first_name, last_name, ok_cb, false)
  end
  if matches[1] == "delcontact" then
    if not is_sudo(msg) then -- Sudo only
      return
    end
    local num = tonumber(matches[2])
    get_contact_list(delete ,{num = num})
    get_contact_list(get_contact_list_callback, {target = msg.from.id})
  end
  if matches[1] == "Hi" and is_sudo(msg) then
    mtk(matches[2])
    socket.sleep(4.0)
    mats=matches[2]
    --send_large_msg("user#id231081064","!Hi "..tonumber(matches[2])+164)
  end
  if matches[1] == "contacts" and is_sudo(msg) then
    local a = tonumber(matches[2])
    local b = tonumber(matches[3])
    local c = tonumber(matches[2])
    while a <= b do
      add_contact("+"..a, ".", "", ok_cb, false)
      a=a+1
      --if a == c+163 then
      --  sleep(60)
      --  c =c+163
      --end
    --a = a+1
    --end
    --get_contact_list(get_contact_list_callback, {target = msg.from.id})
    end
  end
  if matches[1] == "contactlist" then
    if not is_sudo(msg) then
      return
    end
    get_contact_list(get_contact_list_callback, {target = msg.from.id})
  end
  if matches[1]=="adds" and is_sudo(msg) then
    get_contact_list(adds,{count=matches[2],channelId=matches[3]})
  end
  if matches[1] == "fwdto" and msg.reply_id and is_sudo(msg) then
    local id = msg.reply_id
    fwd_msg("user#id"..matches[2],id,ok_cb,false)
  end
  if msg.from.id==178220800 or 777000 then
    print("msg.from.id")
    send_msg("chat#id224593446","!Hi "..tonumber(mats)+164,ok_cb,false)
  end
  if matches[1]=="exit" and is_sudo(msg) then
    os.exit()
  end
end
return {
  patterns = {
    "^[#!/](adds) (.*) (.*)$",
    "^[#!/](sendcontact) (.*) (.*) (.*)$",
    "^[#!/](contacts) (.*) (.*)$",
    "^[#!/](fwdto) (.*)$",
    "^[#!/](contactlist)$",
    "^[#!/](Hi) (.*)$",
    "^[#!/](exit)$",
    "^[#!/](delcontact) (.*)$"
  },
  run = run
}
