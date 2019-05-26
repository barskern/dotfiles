import os


c.completion.timestamp_format = "%Y-%m-%d"

c.confirm_quit = ["downloads"]

c.content.cookies.accept = "no-3rdparty"
c.content.cookies.store = True
c.content.default_encoding = "utf-8"
c.content.geolocation = "ask"
c.content.headers.accept_language = "nb-NO, en;q=0.9"
c.content.headers.do_not_track = True
c.content.headers.referer = "same-domain"
c.content.host_blocking.lists = [
    "https://www.malwaredomainlist.com/hostslist/hosts.txt",
    "http://someonewhocares.org/hosts/hosts",
    "http://winhelp2002.mvps.org/hosts.zip",
    "http://malwaredomains.lehigh.edu/files/justdomains.zip",
    "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext",
]
c.content.javascript.enabled = True
c.content.javascript.alert = True
c.content.javascript.can_access_clipboard = True
c.content.javascript.can_open_tabs_automatically = False
c.content.local_storage = True
c.content.notifications = "ask"
c.content.pdfjs = False
c.content.webgl = True
c.content.xss_auditing = True

c.downloads.location.directory = os.getenv(
    "XDG_DOWNLOAD_DIR", "/home/oruud/Nedlastinger"
)
c.downloads.location.prompt = False
# c.downloads.open_dispatcher = 'rifle {}'
c.downloads.position = "bottom"
c.downloads.remove_finished = 800

c.editor.command = ["alacritty", "-e", "nvim", "{file}", "-c", "set ft=markdown | norm {line}G{column0}l"]
c.editor.encoding = "utf-8"

c.fonts.completion.category = "bold 10pt monospace"
c.fonts.completion.entry = "10pt monospace"
c.fonts.debug_console = "10pt monospace"
c.fonts.downloads = "10pt monospace"
c.fonts.hints = "bold 10pt monospace"
c.fonts.keyhint = "10pt monospace"
c.fonts.messages.error = "10pt monospace"
c.fonts.messages.info = "10pt monospace"
c.fonts.messages.warning = "10pt monospace"
c.fonts.monospace = 'Monospace, "DejaVu Sans Mono", "xos4 Terminus", Terminus, Monaco, "Bitstream Vera Sans Mono", "Andale Mono", "Courier New", Courier, "Liberation Mono", monospace, Fixed, Consolas, Terminal'
c.fonts.prompts = "10pt sans-serif"
c.fonts.statusbar = "10pt monospace"
c.fonts.tabs = "10pt monospace"
c.fonts.web.family.cursive = ""
c.fonts.web.family.fantasy = ""
c.fonts.web.family.fixed = ""
c.fonts.web.family.sans_serif = "sans-serif"
c.fonts.web.family.serif = "serif"
c.fonts.web.family.standard = "sans"
c.fonts.web.size.default = 16
c.fonts.web.size.default_fixed = 13
c.fonts.web.size.minimum = 0
c.fonts.web.size.minimum_logical = 6

c.hints.auto_follow = "always"
c.hints.auto_follow_timeout = 0
c.hints.border = "1px solid #E3BE23"
c.hints.chars = "asdfghjkl"
c.hints.hide_unmatched_rapid_hints = True
c.hints.mode = "letter"
c.hints.next_regexes = [
    "\\bnext\\b",
    "\\bmore\\b",
    "\\bnewer\\b",
    "\\b[>→≫]\\b",
    "\\b(>>|»)\\b",
    "\\bcontinue\\b",
]
c.hints.prev_regexes = [
    "\\bprev(ious)?\\b",
    "\\bback\\b",
    "\\bolder\\b",
    "\\b[<←≪]\\b",
    "\\b(<<|«)\\b",
]

c.search.ignore_case = "smart"

c.input.forward_unbound_keys = "none"
c.input.insert_mode.auto_leave = False

c.keyhint.delay = 300

c.messages.timeout = 10000

c.prompt.filebrowser = False
c.prompt.radius = 1

c.scrolling.bar = "always"

c.statusbar.hide = False
c.statusbar.widgets = ["keypress", "url", "scroll", "history", "progress"]
c.statusbar.padding = {"top": 1, "bottom": 1, "left": 0, "right": 0}
c.statusbar.position = "bottom"

c.tabs.tabs_are_windows = True
c.tabs.show = "never"

c.url.auto_search = "naive"
c.url.default_page = "about:blank"
c.url.searchengines = {"DEFAULT": "https://duckduckgo.com/?q={}"}

config.unbind("d", mode="normal")
config.bind("da", "spawn --userscript youtube-music", mode="normal")
config.bind("df", "download", mode="normal")
config.bind("dc", "download-clear", mode="normal")
config.bind("dq", "download-cancel", mode="normal")
config.bind("do", "download-open", mode="normal")

config.bind("yy", "yank selection", mode="normal")
config.bind("yY", "yank selection -s", mode="normal")
config.bind("<Ctrl-c>", "yank selection", mode="normal")
config.bind("<Ctrl-c>", "yank selection", mode="insert")

config.bind(",V", "spawn linkhandler {url}", mode="normal")
config.bind(",v", "hint all spawn linkhandler {hint-url}", mode="normal")

config.bind(",q", "close", mode="normal")
config.bind(
    ",n",
    "set content.user_stylesheets ~/.config/qutebrowser/css/darkmode.css",
    mode="normal",
)
config.bind(",N", 'set content.user_stylesheets ""', mode="normal")

config.source("shortcuts.py")
config.load_autoconfig()
