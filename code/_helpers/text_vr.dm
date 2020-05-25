//Readds quotes and apostrophes to HTML-encoded strings
/proc/readd_quotes(var/t)
	var/list/repl_chars = list("&#34;" = "\"","&#39;" = "'")
	for(var/char in repl_chars)
		var/index = findtext(t, char)
		while(index)
			t = copytext_char(t, 1, index) + repl_chars[char] + copytext_char(t, index+5)
			index = findtext(t, char)
	return t
