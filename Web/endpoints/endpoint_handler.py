from flask import Flask, render_template, flash, request
from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField
from content_loader import content_loader_page
from werkzeug.utils import secure_filename
from pytube import YouTube
from scraping.wikikit import WikiKit
import os

class EndpointHandler(object):
    def __init__(self,
                 database=None,
                 root_path=None):
        # set the database
        self.db = database

        # directory of the file being run
        self.root_path = root_path

        # images and videos paths
        self.images_path = os.path.join(self.root_path, "static/images")
        self.videos_path = os.path.join(self.root_path, "static/videos")

        # create a class for this
        self.content_loader = None

    def add_endpoints(self, app):
        """
        Dispatch all of the endpoints in an organized manner.
        """
        @app.route("/")
        def show_homepage():
            books = self.db.collection(u"books").get()
            all_books = [i.to_dict() for i in books]
            return render_template("home.html", books=all_books)

        @app.route("/content_loader", methods=['GET', 'POST'])
        def content_loader_3():
            books = self.db.collection(u"books").get()
            all_books = [i.to_dict() for i in books]
            return content_loader_page(self.db, all_books)

        @app.route("/<bookid>/view_images")
        def homepage(bookid):
            images = self.db.collection(u"books").document(bookid).collection("images").get()
            all_images = [i.to_dict() for i in images]
            books = self.db.collection(u"books").get()
            all_books = [i.to_dict() for i in books]
            return render_template("index.html", images=all_images, books=all_books)

        @app.route('/static/videos/')
        def dir_listing_videos():
            BASE_DIR = '/home/moinnadeem/leARn/Web/static/videos/'
            files = os.listdir(self.videos_path)
            return render_template('files.html', files=files)

        @app.route('/static/images/')
        def dir_listing_images():
            files = os.listdir(self.images_path)
            return render_template('files.html', files=files)