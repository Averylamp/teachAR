from flask import Flask, render_template, flash, request, redirect, url_for
from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField
from google.cloud import firestore
from content_loader import content_loader_page
import csv
import os
import glob

# TODO(ethan): remove debug
DEBUG=True

app = Flask(__name__)
app.config.from_object(__name__)
app.config['SECRET_KEY'] = '7d441f27d441f27567d441f2b6176a'

@app.route("/content_loader", methods=['GET', 'POST'])
def content_loader_3():
    db = firestore.Client()
    books = db.collection(u"books").get()
    all_books = [i.to_dict() for i in books]
    return content_loader_page(db, all_books)

@app.route("/<bookid>/view_images")
def homepage(bookid):
    db = firestore.Client()
    images = db.collection(u"books").document(bookid).collection("images").get()
    all_images = [i.to_dict() for i in images]
    books = db.collection(u"books").get()
    all_books = [i.to_dict() for i in books]
    return render_template("index.html", images=all_images, books=all_books)

@app.route('/static/images/')
def dir_listing():
    BASE_DIR = '/home/moinnadeem/leARn/Web/static/images/'

    files = os.listdir(BASE_DIR)
    return render_template('files.html', files=files)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
