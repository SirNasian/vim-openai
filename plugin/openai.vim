if (!exists("g:openai_api_key"))
	echoerr "g:openai_api_key is not defined!"
endif

if (!exists("g:openai_chat_model"))
	let g:openai_chat_model = "gpt-3.5-turbo"
endif

function! openai#Adjust() range
	let messages = [{ "role": "system", "content": "You are a software development programming assistant" }]
	let messages = add(messages, { "role": "user", "content": printf("```\n%s\n```", join(getline(a:firstline, a:lastline), "\n")) })
	let messages = add(messages, { "role": "user", "content": input("Instruction: ") })

	let command  = ["curl", "https://api.openai.com/v1/chat/completions", "-s"]
	let command  = command->add("-H")->add("Authorization: Bearer " . g:openai_api_key)
	let command  = command->add("-H")->add("Content-Type: application/json")
	let command  = command->add("-d")->add(json_encode({ "model": g:openai_chat_model, "messages": messages}))

	let response = json_decode(system(command))
	let text = response["choices"][0]["message"]["content"]
	let code = substitute(text, "^.*```\\w*\\(.*\\)```.*$", "\\1", "")

	call deletebufline(bufname(), a:firstline, a:lastline)
	call appendbufline(bufname(), a:firstline-1, code->split("\n"))

	let bufname = "openai"
	if (bufwinid(bufname) ==# -1)
		execute "bel vs " . bufname
		set buftype=nofile filetype=markdown wrap
	endif
	call win_gotoid(bufwinid(bufname))
	call deletebufline(bufnr(bufname), 1, "$")
	call appendbufline(bufnr(bufname), 0, text->split("\n"))
endfunction
