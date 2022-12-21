from flask import Flask, render_template, redirect
import random as r

app = Flask(__name__)


@app.route('/')
def index():
    sticker_id = r.randint(58173, 58220)
    return render_template('index.html', sticker_preview=f'sticker{sticker_id}.webp', sticker_lottie=f'sticker{sticker_id}.json')


@app.route('/api-docs')
def api_docs():
    return render_template('docs.html')


@app.route('/donate')
def donate():
    return redirect('https://qiwi.com/n/ROBERT545')


if __name__ == '__main__':
    app.run(port=80, host='0.0.0.0')
