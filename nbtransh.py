#!/usr/bin/env python3
LICENSE = """MIT License

Copyright (c) 2026 tc0512

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""
HELP = """Cmd syntax:
text --from_lang>to_lang

For example:
In[1]: Hello world! --en>zh
你好，世界。

Language labels:
zh=Simplified Chinese
en=English
zh-TW=Traditional Chinese
yve=Cantonese
ko=Korean
fr=French
es=Spanish
it=Italian
nl=Netherlands
tr=Turkey
hi=Hindi
th=thai
el=Greek
sv=Swedish
fi=Finland
cs=Czech
ro=Romanian
ja=Japanese
"""
__version__ = "0.1.0"
class StdinError(Exception):
    pass
class LanguageUnknownError(Exception):
    pass
import rich
from translate import Translator
import platform
from datetime import datetime
python_version = platform.python_version()
now = datetime.now()
time = now.strftime("%Y-%m-%d %H:%M:%S")
print(f"Python {python_version} ({time})")
print("Type 'copyright' or 'license' for more information")
print(f"Nbtransh {__version__} -- an interactive translator. Type '?' for help.\n")
def ShowCopyright():
    print("Copyright (c) 2026 tc0512")
    print("All Rights Reserved.\n")
def ShowLicense():
    print(LICENSE)
def ShowHelpText():
    print(HELP)
def ParseStdin(stdin: str):
    if "--" in stdin:
        text, lang = stdin.split(" --", 1)
    else:
        raise StdinError("no '--' in your input")
    if ">" in lang:
        fromlang, tolang = lang.split(">")
    else:
        raise LanguageUnknownError("language is unknown")
    return text.strip(), fromlang, tolang
def main():
    counter = 1
    while True:
        rich.print(f"[green]In [{counter}]: [/green]", end="")
        stdin = input()
        if stdin=="exit()":
            break
        elif stdin=="copyright":
            ShowCopyright()
        elif stdin=="license":
            ShowLicense()
        elif stdin=="?":
            ShowHelpText()
        else:
            try:
                text, fromlang, tolang = ParseStdin(stdin)
                translator = Translator(from_lang=fromlang, to_lang=tolang)
                print(translator.translate(text))
                print("\n", end="")
            except Exception as e:
                rich.print(f"[red]Error:{e}[/red]")
                print("\n", end="")
        counter+=1
if __name__=="__main__":
    main()
