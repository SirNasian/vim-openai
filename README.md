# openai.vim

This Vim plugin allows you to communicate with OpenAI's natural language processing models directly from your Vim editor.

This plugin is intended to be used as a programming assistant to get code suggestions, explanations, and reviews by selecting code and asking OpenAI models for help.

## Prerequisites

- Ensure that you have a valid [OpenAI API key](https://platform.openai.com/docs/api-reference/authentication).
- Ensure that `curl` is installed on your system.

## Installation

Use your preferred plugin manager to install this plugin. For example, if you use [vim-plug](https://github.com/junegunn/vim-plug), add the following line to your `~/.vimrc` file:

```
Plug 'SirNasian/vim-openai'
```

Then run the following command in Vim:

```
:PlugInstall
```

or alternatively, if you don't want to use a plugin manager, just drop `openai.vim` into your `plugins` folder!

## Usage

### Commands

This plugin provides 4 commands:

- `:OpenAIAdjust`: Adjust or rewrite the selected code based on user input.
- `:OpenAIExplain`: Provide an explanation of what the selected code does.
- `:OpenAIReview`: Review the selected code and give recommendations for how it can be improved.
- `:OpenAIAsk`: Ask a general question about the selected code.

### Configuration

The following variables are available for configuration:

- `g:openai_api_key`: Your OpenAI API key that will be used to authenticate requests to the API. Ensure this variable is set in your `vimrc`.
- `g:openai_chat_model`: The name of the OpenAI model to use for chat interactions. This is set to `gpt-3.5-turbo` by default.
    - _Refer to the [model endpoint compatability list](https://platform.openai.com/docs/models/model-endpoint-compatibility) for the `/v1/chat/completions` endpoint for possible configuration values._
