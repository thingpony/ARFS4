/proc/send2irc(var/channel, var/msg)
	if(config.use_irc_bot && config.irc_bot_host)
		spawn(0)
			log_debug("send2irc: Sending [msg] to [channel]")
			paranoid_sanitize(msg)
			ext_python("ircbot_message.py", "[config.comms_password] [config.irc_bot_host] [channel] [dbcon.Quote(msg)]")
	return

/proc/send2mainirc(var/msg)
	if(config.main_irc)
		send2irc(config.main_irc, msg)
	return

/proc/send2adminirc(var/msg)
	var/queuedmsg = "ADMIN - [msg]"

	send2irc(config.admin_irc, queuedmsg)
	return

/proc/send2generalirc(var/msg)
	var/queuedmsg = "RADIO - [msg]"

	send2irc(config.main_irc, queuedmsg)
	return

/proc/send2commandirc(var/msg)
	var/queuedmsg = "ANNOUNCEMENT - [msg]"

	send2irc(config.main_irc, queuedmsg)
	return

/hook/startup/proc/ircNotify()
	send2mainirc("Server starting up on [config.server? "byond://[config.server]" : "byond://[world.address]:[world.port]"]")
	return 1

/proc/paranoid_sanitize(t)
	var/regex/alphanum_only = regex("\[^a-zA-Z0-9# ,.?!:;()]", "g")
	return alphanum_only.Replace(t, "#")