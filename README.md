# Evilmacs
## An anarchic (no clear leader) take on Emacs Evil Mode
I like Vim. I like org-mode. Something had to be done. Something complex enough to keep in version control.

The important bits are in the init.el file. Almost everything is configured to use LSP, with a few exceptions (Clojure springs to mind). Whenever possible, follows (use-package) idioms. Some things are screwy. At time of writing, I don't know if Erlang mode works, but it once did, so at least this has historic value.

Includes relative line numbers and powerline because I like to feel like I'm playing Mechwarrior II at work.

Combines ivy, counsel, smex, and projectile to do what Vim never could -- sanely manage viewing multiple projects at once.

Includes special support for:
* Golang
* JavaScript + JSX
* Haskell -- With after install details on how to get HLint working (it's worth it!)
* Clojure
* WASM ([the s-expression sort](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format))
* Rust
* HTML + CSS
* Markdown

Also uses three leader keys, (" ", ",", and "g") as "dear-leader", "scholar", and "despot" with the roles of "Interacting With Other Files", "Interacting With Current File", and "Interacting With The Outside World + gofmt", obviously. YMMV.

Special thanks to [this](https://sam217pa.github.io/2016/09/02/how-to-build-your-own-spacemacs/) and [this](https://jamiecollinson.com/blog/my-emacs-config/) who I apparently copied/pasted enough from to shout out in the top level of init.el
