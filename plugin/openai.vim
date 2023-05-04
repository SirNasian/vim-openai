if (!exists("g:openai_api_key"))
	echoerr "g:openai_api_key is not defined!"
endif

if (!exists("g:openai_chat_model"))
	let g:openai_chat_model = "gpt-3.5-turbo"
endif

function! openai#GetCodeSelection(start, end)
	let lines = getline(a:start, a:end)
	let lines = join(lines, "\n")
	return "```\n" . lines . "\n```"
endfunction

function! openai#Request(messages)
	let l:command = ["curl", "https://api.openai.com/v1/chat/completions", "-s"]
	call add(l:command, "-H")->add("Authorization: Bearer " . g:openai_api_key)
	call add(l:command, "-H")->add("Content-Type: application/json")
	call add(l:command, "-d")->add(json_encode({ "model": g:openai_chat_model, "messages": a:messages}))
	return json_decode(system(l:command))["choices"][0]["message"]["content"]
endfunction

function! openai#ShowMessage(message)
	let bufname = "openai"
	if (len(win_findbuf(bufnr(bufname))) == 0)
		execute "bel vs " . bufname
		set buftype=nofile filetype=markdown wrap
	endif
	call win_gotoid(win_findbuf(bufnr(bufname))[0])
	call deletebufline(bufnr(bufname), 1, "$")
	call appendbufline(bufnr(bufname), 0, a:message->split("\n"))
endfunction

function! openai#Adjust(...) range
	let l:messages = []
	call add(l:messages, { "role": "system", "content": "You are a software development programming assistant" })
	call add(l:messages, { "role": "user",   "content": openai#GetCodeSelection(a:firstline, a:lastline) })
	call add(l:messages, { "role": "user",   "content": input("Instruction: ") })

	let l:response = openai#Request(l:messages)
	let l:code = substitute(l:response, "^.*```\\w*\\(.*\\)```.*$", "\\1", "")

	call deletebufline(bufname(), a:firstline, a:lastline)
	call appendbufline(bufname(), a:firstline-1, l:code->split("\n"))

	if (exists("a:1") && a:1)
		call openai#ShowMessage(l:response)
	endif
endfunction

function! openai#Explain() range
	let l:messages = []
	call add(l:messages, { "role": "system", "content": "You are a software development programming assistant" })
	call add(l:messages, { "role": "user",   "content": "What does the following code do?" })
	call add(l:messages, { "role": "user",   "content": openai#GetCodeSelection(a:firstline, a:lastline) })
	let l:response = openai#Request(l:messages)
	call openai#ShowMessage(l:response)
endfunction

function! openai#Review() range
	let l:messages = []
	call add(l:messages, { "role": "system", "content": "You are a software development programming assistant" })
	call add(l:messages, { "role": "user",   "content": "How can the following code be improved?" })
	call add(l:messages, { "role": "user",   "content": openai#GetCodeSelection(a:firstline, a:lastline) })
	let l:response = openai#Request(l:messages)
	call openai#ShowMessage(l:response)
endfunction
