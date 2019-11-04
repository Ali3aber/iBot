
Redis =  require ('redis')
redis = Redis.connect('127.0.0.1', 6379)
SUDO_ID = {300131107}
TD_ID = redis:get('Cleaner-ID')
function is_sudo(msg)
  local var = false
 for v,user in pairs(SUDO_ID) do
    if user == msg.sender_user_id then
      var = true
    end
  end
  if redis:sismember("SUDO-ID", msg.sender_user_id) then
    var = true
  end
  return var
end
function is_Cleaner(msg) 
  local hash = redis:sismember('Cleaner:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) then
return true
else
return false
end
end
function is_PlusCleaner(msg) 
  local hash = redis:sismember('PlusCleaner:'..msg.chat_id,msg.sender_user_id)
if hash or is_Cleaner(msg) or is_sudo(msg) then
return true
else
return false
end
end
local function getMe(cb)
  	assert (tdbot_function ({
    	_ = "getMe",
    }, cb, nil))
end
function do_notify (user, msg)
	local n = notify.Notification.new(user, msg)
	n:show ()
end
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)

  if chat_id:match('^-100') then
    local channel_id = chat_id:gsub('-100', '')
    chat = {id = channel_id, type = 'channel'}
  else
    local group_id = chat_id:gsub('-', '')
    chat = {id = group_id, type = 'group'}
  end

  return chat
end
function RemoveFromBanList(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatusLeft"
},
}, dl_cb, nil)
end
function KickUser(chat_id, user_id)
  	tdbot_function ({
    	_ = "changeChatMemberStatus",
    	chat_id = chat_id,
    	user_id = user_id,
    	status = {
      		_ = "chatMemberStatusBanned"
    	},
  	}, dl_cb, nil)
end
function getChatHistory(chat_id, from_message_id, offset, limit,cb)
  tdbot_function ({
    _ = "getChatHistory",
    chat_id = chat_id,
    from_message_id = from_message_id,
    offset = offset,
    limit = limit
  }, cb, nil)
end
function deleteMessagesFromUser(chat_id, user_id)
  tdbot_function ({
    _ = "deleteMessagesFromUser",
    chat_id = chat_id,
    user_id = user_id
  }, dl_cb, nil)
end
 function deleteMessages(chat_id, message_ids)
  tdbot_function ({
    _= "deleteMessages",
    chat_id = chat_id,
    message_ids = message_ids -- vector {[0] = id} or {id1, id2, id3, [0] = id}
  }, dl_cb, nil)
end
local function getMessage(chat_id, message_id,cb)
 tdbot_function ({
    	_ = "getMessage",
    	chat_id = chat_id,
    	message_id = message_id
  }, cb, nil)
end
local function GeChat(chatid,cb)
 assert (tdbot_function ({
    _ = 'getChat',
    chat_id = chatid
 }, cb, nil))
end
function sendText(chat_id,msg, text, parse)
    assert( tdbot_function ({
    	_ = "sendMessage",
    	chat_id = chat_id,
    	reply_to_message_id = msg,
    	disable_notification = 0,
    	from_background = 1,
    	reply_markup = nil,
    	input_message_content = {
    		_ = "inputMessageText",
    		text = text,
    		disable_web_page_preview = 1,
    		clear_draft = 0,
    		parse_mode = getParse(parse),
    		entities = {}
    	}
    }, dl_cb, nil))

end

function  viewMessages(chat_id, message_ids)
  	tdbot_function ({
    	_ = "viewMessages",
    	chat_id = chat_id,
    	message_ids = message_ids
  }, dl_cb, nil)
end
function getChannelMembers(channelid, off, lim, mbrfilter,cb)
  local lim = lim or 200
  lim = lim > 200 and 200 or lim
  assert (tdbot_function ({
    _ = 'getChannelMembers',
    channel_id = getChatId(channelid).id,
    filter = {
      _ = 'channelMembersFilter' .. mbrfilter,
    },
    offset = off,
    limit = lim
  }, cb, nil))
  
end
  
local function vardump(value)
  print '\n-------------------------------------------------------------- START'
  print(serpent.block(value, {comment=false}))
  print '--------------------------------------------------------------- STOP\n'
end
function dl_cb(arg, data)
  -- print '\n===================================================================='
  vardump(arg)
  vardump(data)
  -- print '--==================================================================\n'
end
 function showedit(msg,data)
         if msg then
   viewMessages(msg.chat_id, {[0] = msg.id})
      if msg.send_state._ == "messageIsSuccessfullySent" then
      return false 
      end   
if not redis:sismember('AllGroup',msg.chat_id) then
       redis:sadd('AllGroup',msg.chat_id)
end  
------------Chat Type------------
function is_supergroup(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-100') then 
    if not msg.is_post then
    return true
    end
  else
    return false
  end
end
function mute(chat_id, user_id, Restricted, right)
  local chat_member_status = {}
 if Restricted == 'Restricted' then
    chat_member_status = {
     is_member = right[1] or 1,
      restricted_until_date = right[2] or 0,
      can_send_messages = right[3] or 1,
      can_send_media_messages = right[4] or 1,
      can_send_other_messages = right[5] or 1,
      can_add_web_page_previews = right[6] or 1
         }

  chat_member_status._ = 'chatMemberStatus' .. Restricted

  assert (tdbot_function ({
    _ = 'changeChatMemberStatus',
    chat_id = chat_id,
    user_id = user_id,
    status = chat_member_status
   }, dl_cb, nil))
end
end
function is_channel(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-100') then 
  if msg.is_post then -- message is a channel post
    return true
  else
    return false
  end
  end
end

function is_group(msg)
  chat_id= tostring(msg.chat_id)
  if chat_id:match('^-100') then 
    return false
  elseif chat_id_:match('^-') then
    return true
  else
    return false
  end
end
function getParse(parse)
	if parse  == 'md' then
		return {_ = "textParseModeMarkdown"}
	elseif parse == 'html' then
		return {_ = "textParseModeHTML"}
	else
		return nil
	end
end

function is_private(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-') then
    return false
  else
    return true
  end
end
function Left(chat_id, user_id, s)
   assert (tdbot_function ({
    _ = "changeChatMemberStatus",
    chat_id = chat_id,
    user_id = user_id,
    status = {
      _ = "chatMemberStatus" ..s
    },
  }, dl_cb, nil))
end
local function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
function check_markdown(text)
		str = text
		if str:match('_') then
			output = str:gsub('_',[[\_]])
		elseif str:match('*') then
			output = str:gsub('*','\\*')
		elseif str:match('`') then
			output = str:gsub('`','\\`')
		else
			output = str
		end
	return output
end
-------------MSG MATCHES------------
local cerner = msg.content.text
		 if msg_type == 'text' and cerner then
      if cerner:match('^[/#]') then
      cerner=  cerner:gsub('^[/#]','')
      end
    end
if cerner then
cerner = cerner:lower()
end
--------------MSG TYPE----------------
 if msg.content._== "messageText" then
         print("This is [ TEXT ]")
      msg_type = 'text'
    end
if cerner == 'id' then
 sendText(msg.chat_id,msg.id,'*Chat ID :* [`'..msg.chat_id..'`*]*\n*User ID : [*`'..msg.sender_user_id..'`*]*', 'md')
end

if is_sudo(msg) then
if cerner== 'leave' then
Left(msg.chat_id, TD_ID, 'Left')
end

if cerner == 'reload' then
dofile('./ibot/keepercli/plugins/iCBeta.lua')
sendText(msg.chat_id, msg.id,'iCBeta Reloaded',0)
end
if cerner == 'bc' and tonumber(msg.reply_to_message_id) > 0 then
function CerNerCompany(CerNer,Company)
local text = Company.content.text
local list = redis:smembers('CompanyAll')
for k,v in pairs(list) do
sendText(v, 0, text, 'md')
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),CerNerCompany)
end
if cerner == 'fwd' and tonumber(msg.reply_to_message_id) > 0 then
function CerNerCompany(CerNer,Company)
local list = redis:smembers('CompanyAll')
for k,v in pairs(list) do
ForMsg(v, msg.chat_id, {[0] = Company.id}, 1)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),CerNerCompany)
end
if cerner == 'add' then
redis:set('CheckBot:'..msg.chat_id,true)
sendText(msg.chat_id, msg.id,'گروه در لیست قرار گرفت',0)
end
if cerner == 'rem' then
redis:del('CheckBot:'..msg.chat_id)
sendText(msg.chat_id, msg.id,'گروه از لیست حذف شد',0)
end
if cerner and cerner:match('^setcleaner (%d+)') then
local user = cerner:match('setcleaner (%d+)')
redis:sadd('Cleaner:'..msg.chat_id,user)
sendText(msg.chat_id, msg.id, 'User `'..user..'`* Has Been Cleaner*', 'md')
end
if cerner == 'setcleaner' then
function SetCleanerByReply(CerNer,Company)
if redis:sismember('Cleaner:'..msg.chat_id, Company.sender_user_id) then
sendText(msg.chat_id, msg.id,  '`User : ` *'..Company.sender_user_id..'* is *Already* `a Cleaner..!`', 'md')
else
sendText(msg.chat_id, msg.id,'_ User : _ `'..Company.sender_user_id..'` *Promoted* to `Cleaner` ..', 'md')
redis:sadd('Cleaner:'..msg.chat_id,Company.sender_user_id)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetCleanerByReply)
end
if cerner == 'delcleaner' then
function SetCleanerByReply(CerNer,Company)
if redis:sismember('Cleaner:'..msg.chat_id, Company.sender_user_id) then
sendText(msg.chat_id, msg.id,'_ User : _ `'..Company.sender_user_id..'` *Removed* from `CleanerList` ..', 'md')
else
sendText(msg.chat_id, msg.id,  '`User : ` *'..Company.sender_user_id..'* is *Not* ` Cleaner..!`', 'md')
redis:srem('Cleaner:'..msg.chat_id,Company.sender_user_id)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetCleanerByReply)
end
if cerner == 'clean members' then 
    function CleanDeleted(CerNer, Company) 
    for k, v in pairs(Company.members) do 
 if tonumber(v.user_id) == tonumber(TD_ID) then
   return true
else
KickUser(msg.chat_id,v.user_id)
end
end
end
print('CerNer')
getChannelMembers(msg.chat_id, 1, 2000000, "Recent",CleanDeleted)
sendText(msg.chat_id, msg.id,'Done\nAll Memers  Has Been Kicked', 'md') 
end 
if cerner == 'cleanerlist' then
local Cleaner = redis:smembers('Cleaner:'..msg.chat_id)
local t = 'Cleaners \n'
for k,v in pairs(Cleaner) do
t = t..k.." - *"..v.."*\n" 
end
if #Cleaner == 0 then
t = 'Nil'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
end
if is_Cleaner(msg) then
if cerner == 'clean restricts' then
local function pro(arg,data)
if redis:get("Check:Restricted:"..msg.chat_id) then
text = 'هر 5دقیقه یکبار ممکن است'
end
for k,v in pairs(data.members) do
redis:del('MuteAll:'..msg.chat_id)
 mute(msg.chat_id, v.user_id,'Restricted',    {0, 0, 0, 0, 1,1})
   redis:setex("Check:Restricted:"..msg.chat_id,350,true)
end
end
getChannelMembers(msg.chat_id, 0, 100000000000, "Recent",pro)
sendText(msg.chat_id, msg.id,'All Members Has Been Restricted' ,'md')
end  
if cerner == 'clean bots'  then
local function CleanBot(CerNer,Company)
for k,v in pairs(Company.members) do
KickUser(msg.chat_id, v.user_id) 
end
end
sendText(msg.chat_id, msg.id,  'All Bots  Has Been Kicked', 'md')
getChannelMembers(msg.chat_id,0, 2000000000, "Bots",CleanBot)
end
  if cerner == 'clean banlist'  then
local function Clean(CerNer,Company)
for k,v in pairs(Company.members) do
redis:del('BanUser:'..msg.chat_id)
RemoveFromBanList(msg.chat_id, v.user_id) 
end
end
sendText(msg.chat_id, msg.id,  'All User Banned Has Been Cleaned From BanList', 'md')
getChannelMembers(msg.chat_id, 0, 200, "Banned",Clean)
end
if cerner == 'پاک سازی'  then
local function cb(arg,data)
for k,v in pairs(data.messages) do
deleteMessages(msg.chat_id,{[0] =v.id})
print 'Clean By ID Msg ' 
end
end
getChatHistory(msg.chat_id,msg.id, 0,  500000000,cb)
 end
if cerner == 'پاک سازی'  then
 local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Del From User ' 
end
end
getChannelMembers(msg.chat_id, 0, 200000, "Recent",pro)
sendText(msg.chat_id, msg.id,'درحال پاکسازی تمامی پیامهای گروه🗑' ,'md')
end
if cerner == 'پاک سازی'  then
local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Banned User ' 
end
end
getChannelMembers(msg.chat_id, 0, 2000000000, "Banned",pro)
end
if cerner == 'پاک سازی'  then
local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Search' 
end
end
getChannelMembers(msg.chat_id, 0, 20000, "Search",pro)
end
if cerner == 'پاک سازی'  then
local function cb(arg,data)
for k,v in pairs(data.messages) do
deleteMessages(msg.chat_id,{[0] =v.id})
print 'Clean By ID Msg ' 
end
end
getChatHistory(msg.chat_id,msg.id, 0,  500000000,cb)
        end
if cerner == 'پاک سازی'  then
 local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Del From User ' 
end
end
getChannelMembers(msg.chat_id, 0, 200000, "Recent",pro)
sendText(msg.chat_id, msg.id,'درحال پاکسازی تمامی پیامهای گروه🗑' ,'md')
end
if cerner == 'پاک سازی'  then
local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Banned User ' 
end
end
getChannelMembers(msg.chat_id, 0, 2000000000, "Banned",pro)
end
if cerner == 'پاک سازی'  then
local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Search' 
end
end
getChannelMembers(msg.chat_id, 0, 20000, "Search",pro)
end
if cerner == 'پاک سازی'  then
local function cb(arg,data)
for k,v in pairs(data.messages) do
deleteMessages(msg.chat_id,{[0] =v.id})
print 'Clean By ID Msg ' 
end
end
getChatHistory(msg.chat_id,msg.id, 0,  500000000,cb)
        end
if cerner == 'پاک سازی'  then
 local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Del From User ' 
end
end
getChannelMembers(msg.chat_id, 0, 200000, "Recent",pro)
sendText(msg.chat_id, msg.id,'درحال پاکسازی تمامی پیامهای گروه🗑' ,'md')
end
if cerner == 'پاک سازی'  then
local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Banned User ' 
end
end
getChannelMembers(msg.chat_id, 0, 2000000000, "Banned",pro)
end
if cerner == 'پاک سازی'  then
local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Search' 
end
end
getChannelMembers(msg.chat_id, 0, 20000, "Search",pro)
end
if cerner == 'پاک سازی'  then
local function cb(arg,data)
for k,v in pairs(data.messages) do
deleteMessages(msg.chat_id,{[0] =v.id})
print 'Clean By ID Msg ' 
end
end
getChatHistory(msg.chat_id,msg.id, 0,  500000000,cb)
        end
if cerner == 'پاک سازی'  then
 local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Del From User ' 
end
end
getChannelMembers(msg.chat_id, 0, 200000, "Recent",pro)
sendText(msg.chat_id, msg.id,'درحال پاکسازی تمامی پیامهای گروه🗑' ,'md')
end
if cerner == 'پاک سازی'  then
local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Banned User ' 
end
end
getChannelMembers(msg.chat_id, 0, 2000000000, "Banned",pro)
end
if cerner == 'پاک سازی'  then
local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Search' 
end
end
getChannelMembers(msg.chat_id, 0, 20000, "Search",pro)
end
if cerner == 'پاک سازی'  then
local function cb(arg,data)
for k,v in pairs(data.messages) do
deleteMessages(msg.chat_id,{[0] =v.id})
print 'Clean By ID Msg ' 
end
end
getChatHistory(msg.chat_id,msg.id, 0,  500000000,cb)
        end
if cerner == 'پاک سازی'  then
 local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Del From User ' 
end
end
getChannelMembers(msg.chat_id, 0, 200000, "Recent",pro)
sendText(msg.chat_id, msg.id,'Done' ,'md')
end
if cerner == 'پاک سازی'  then
local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Banned User ' 
end
end
getChannelMembers(msg.chat_id, 0, 2000000000, "Banned",pro)
end
if cerner == 'پاک سازی'  then
local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Search' 
end
end
getChannelMembers(msg.chat_id, 0, 20000, "Search",pro)
end
end
end
sendText(msg.chat_id, msg.id, txt, 0)
end
--------------
if cerner  then
if not redis:get('Cleaner-ID') then
local function cb(a,b,c)
redis:set('Cleaner-ID',b.id)
end
getMe(cb)
end
end
end
end
 ------CerNer Company---------
 
function tdbot_update_callback(data)
    if (data._ == "updateNewMessage") or (data._ == "updateNewChannelMessage") then
     showedit(data.message,data)
vardump(data)
     elseif (data._== "updateMessageEdited") then
    data = data
    local function edit(extra,result,success)
      showedit(result,data)
    end
		tdbot_function ({
    	_ = "openChat",
    	chat_id = data.chat_id
}, dl_cb, nil)
     tdbot_function ({
	 _ = "getMessage", 
	 chat_id = data.chat_id,
	 message_id = data.message_id
	 }, edit, nil)
 assert (tdbot_function ({
    _ = 'openMessageContent',
    chat_id = data.chat_id,
    message_id = data.message_id
	}, dl_cb, nil))
    tdbot_function ({
	_="getChats",
	offset_order="9223372036854775807",
	offset_chat_id=0,
	limit=20
	}, dl_cb, nil)

end
end
---End Version 1 
