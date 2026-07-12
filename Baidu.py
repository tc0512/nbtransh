#!/usr/bin/env python3
import requests
import hashlib
import random
import json
def baidu_translate(text, from_lang, to_lang, appid, secret):
    salt = str(random.randint(32768, 65536))
    sign_str = appid + text + salt + secret
    sign = hashlib.md5(sign_str.encode()).hexdigest()
    url = 'https://fanyi-api.baidu.com/api/trans/vip/translate'
    params = {
        'q': text,
        'from': from_lang,
        'to': to_lang,
        'appid': appid,
        'salt': salt,
        'sign': sign
    }
    resp = requests.get(url, params=params)
    result = resp.json()

    if 'trans_result' in result:
        return result['trans_result'][0]['dst']
    else:
        return f"Failed to translate: {result}"
