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
zh-TW=Traditional Chinese
yue=Cantonese
en=English
ja=Japanese
ko=Korean
fr=French
es=Spanish
it=Italian
nl=Netherlands
tr=Turkey
hi=Hindi
th=Thai
el=Greek
sv=Swedish
fi=Finland
cs=Czech
ro=Romanian
pt=Portuguese
de=German
ru=Russian

Dictionary commands:
%dictionary generate          - Create an empty dictionary
%dictionary add <word> <lang> <trans> - Add translation
%dictionary list              - Show all entries
%dictionary show <word>       - Show translations of a word
%dictionary remove <word>     - Remove a word
%dictionary clear             - Clear all entries

Show history:
%history or %hist
"""
__version__ = "0.3.0"
import os
import sys
import json
import platform
from datetime import datetime
from pathlib import Path
try:
    from translate import Translator
except ImportError:
    print("Error: 'translate' module not installed.")
    print("Run: pip install translate")
    sys.exit(1)
try:
    import rich
except ImportError:
    class RichFallback:
        @staticmethod
        def print(*args, **kwargs):
            builtins_print = __builtins__.get('print') if isinstance(__builtins__, dict) else print
            builtins_print(*args)
    rich = RichFallback()
def get_dict_path():
    """Get dictionary file path (same directory as script)"""
    return Path(__file__).parent / "dictionary.json"
def LoadDictionary():
    """Load dictionary from JSON file"""
    dict_path = get_dict_path()
    if dict_path.exists() and dict_path.stat().st_size>0:
        try:
            with open(dict_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except json.JSONDecodeError:
            print("Warning: Dictionary file is corrupted. Creating new one.\n")
            return {}
    return {}
def SaveDictionary(dictionary):
    """Save dictionary to JSON file"""
    dict_path = get_dict_path()
    with open(dict_path, 'w', encoding='utf-8') as f:
        json.dump(dictionary, f, indent=2, ensure_ascii=False)
def GenerateDictionary():
    """Create an empty dictionary file if not exists"""
    dict_path = get_dict_path()
    if dict_path.exists() and dict_path.stat().st_size>0:
        print("Json file `dictionary.json` already exists.\n")
    else:
        with open(dict_path, 'w', encoding='utf-8') as f:
            json.dump({}, f)
        print("Created a json file `dictionary.json`.\n")
def AddDictionaryEntry(word, lang, translation):
    """Add or update a translation entry"""
    dictionary = LoadDictionary()
    if word not in dictionary:
        dictionary[word] = {}
    dictionary[word][lang] = translation
    SaveDictionary(dictionary)
    print(f"Added: {word} ({lang}) -> {translation}\n")
def RemoveDictionaryEntry(word):
    """Remove a word from dictionary"""
    dictionary = LoadDictionary()
    if word in dictionary:
        del dictionary[word]
        SaveDictionary(dictionary)
        print(f"Removed: {word}\n")
    else:
        print(f"Word '{word}' not found in dictionary.\n")
def ClearDictionary():
    """Clear all dictionary entries"""
    SaveDictionary({})
    print("Dictionary cleared.\n")
def ListDictionary():
    """List all dictionary entries"""
    dictionary = LoadDictionary()
    if dictionary:
        for word, translations in dictionary.items():
            trans_str = ", ".join([f"{lang}: {text}" for lang, text in translations.items()])
            print(f"  {word} -> {trans_str}")
        print()
    else:
        print("Dictionary is empty.\n")
def ShowDictionaryEntry(word):
    """Show translations of a specific word"""
    dictionary = LoadDictionary()
    if word in dictionary:
        print(f"  {word}:")
        for lang, trans in dictionary[word].items():
            print(f"    {lang}: {trans}")
        print()
    else:
        print(f"'{word}' not found in dictionary.\n")
def TranslateWithDictionary(text, from_lang, to_lang):
    """
    Translate text using local dictionary first, then online API
    """
    dictionary = LoadDictionary()
    if text in dictionary:
        word_dict = dictionary[text]
        if to_lang in word_dict:
            return word_dict[to_lang]
        if "en" in word_dict:
            rich.print("[yellow](Language not found, using English fallback)[/yellow]")
            return word_dict["en"]
    try:
        translator = Translator(from_lang=from_lang, to_lang=to_lang)
        return translator.translate(text)
    except Exception as e:
        return f"[Translation Error: {e}]"
def get_history_file_path():
    """Get history file path (same directory as script)"""
    return Path(__file__).parent / "history.txt"
def CheckHistoryFile():
    """Create an empty history file if not exists"""
    history_file_path = get_history_file_path()
    if history_file_path.exists() and history_file_path.stat().st_size>0:
        pass
    else:
        with open(history_file_path, 'w', encoding='utf-8') as f:
            f.write("")
class StdinError(Exception):
    pass
class LanguageUnknownError(Exception):
    pass
def ParseStdin(stdin: str):
    """Parse input string into text, from_lang, to_lang"""
    if "--" not in stdin:
        raise StdinError("no '--' in your input")
    text, lang_part = stdin.split(" --", 1)
    if ">" not in lang_part:
        raise LanguageUnknownError("language format error, expected: from>to")
    from_lang, to_lang = lang_part.split(">", 1)
    return text.strip(), from_lang.strip(), to_lang.strip()
def ShowCopyright():
    print("Copyright (c) 2026 tc0512")
    print("All Rights Reserved.\n")
def ShowLicense():
    print(LICENSE)
def ShowHelpText():
    print(HELP)
def main():
    python_version = platform.python_version()
    now = datetime.now()
    time_str = now.strftime("%Y-%m-%d %H:%M:%S")
    CheckHistoryFile()
    print(f"Python {python_version} ({time_str})")
    print("Type 'copyright' or 'license' for more information")
    print(f"Nbtransh {__version__} -- an interactive translator. Type '?' for help.\n")
    
    counter = 1
    
    while True:
        now = datetime.now()
        time_str = now.strftime("%Y-%m-%d %H:%M:%S")
        rich.print(f"[green]In [{counter}]: [/green]", end="")
        
        try:
            stdin = input()
        except EOFError:
            print("\n")
            break
        except KeyboardInterrupt:
            print("\n")
            break
        
        # Empty line
        if stdin == "" or stdin.isspace():
            print()
        
        # Exit
        elif stdin == "exit()":
            break
        
        # Info commands
        elif stdin == "copyright":
            ShowCopyright()
        elif stdin == "license":
            ShowLicense()
        elif stdin == "?":
            ShowHelpText()
        
        # Dictionary commands
        elif stdin == "%dictionary generate":
            GenerateDictionary()
        
        elif stdin.startswith("%dictionary add "):
            parts = stdin.split()
            if len(parts) >= 4:
                word = parts[2]
                lang = parts[3]
                translation = " ".join(parts[4:]) if len(parts)>4 else ""
                if not translation:
                    translation = input("  Translation:  ").strip()
                if translation:
                    AddDictionaryEntry(word, lang, translation)
                else:
                    print("Translation cannot be empty.\n")
            else:
                print("Usage: %dictionary add <word> <lang> <translation>\n")
        
        elif stdin.startswith("%dictionary remove "):
            word = stdin.split(" ", 2)[2]
            RemoveDictionaryEntry(word)
        
        elif stdin == "%dictionary clear":
            ClearDictionary()
        
        elif stdin == "%dictionary list":
            ListDictionary()
        
        elif stdin.startswith("%dictionary show "):
            word = stdin.split(" ", 2)[2]
            ShowDictionaryEntry(word)
        
        elif stdin.startswith("%dictionary "):
            print("Unknown dictionary command. Type '?' for help.\n")
        
        # History
        elif stdin=="%history" or stdin=="%hist":
            with open(get_history_file_path(), 'r', encoding='utf-8') as f:
                print(f.read())
            print()
        
        # Translation
        else:
            try:
                text, from_lang, to_lang = ParseStdin(stdin)
                result = TranslateWithDictionary(text, from_lang, to_lang)
                print(result)
                print()
            except StdinError:
                rich.print("[red]Error: Missing '--' separator. Use: text --en>zh[/red]\n")
            except LanguageUnknownError:
                rich.print("[red]Error: Invalid language format. Use: --en>zh[/red]\n")
            except Exception as e:
                rich.print(f"[red]Error: {e}[/red]\n")
        
        # Write into history file
        with open(get_history_file_path(), 'a', encoding='utf-8') as f:
            f.write(f"[{time_str}] {stdin}\n")

        counter += 1


if __name__ == "__main__":
    main()
