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
    return render_template(
        'index.html',
            sticker_preview=f'sticker{sticker_id}.webp',
            sticker_lottie=f'sticker{sticker_id}.json'
    )


@me.route('/api-docs')
def api_docs():
    with open('static/methods.json', 'r') as f:
        api_methods = json.load(f)
    return render_template('docs.html', apiMethods=api_methods)


@me.route('/donate')
def donate():
    return redirect('https://www.tinkoff.ru/cf/3Tkl3awpS5c')


app.register_blueprint(me)

if __name__ == '__main__':
    app.run(port=80, host='0.0.0.0')
