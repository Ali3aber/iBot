local function run(msg, matches)
if matches[1] == "علی صابر" then
      if msg.to.type == 'channel' or 'chat' then
            local answers = {'🥰😍وای باباییم😍😍','باباییه من'}
            return answers[math.random(#answers)]
      end
	   end
     	  if matches[1] == "alisaber" then
      if msg.to.type == 'channel' or 'chat' then
           local answers = {'وایی عشقم بابام','با بابام کاری داری؟','عشق منهه که','دوست دارم بابایی','بابایی بیا کارت دارن','واییی باباییییی','بوج برای بابام'}
            return answers[math.random(#answers)]
      end
	  end
    end
return
  patterns = {
  "alisaber$",
  "علی صابر"
}
  run = run
