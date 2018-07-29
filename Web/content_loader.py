from flask import Flask, render_template, flash, request
from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField
from werkzeug.utils import secure_filename
from objects import Book, Image
import os

def process_image_form(db, bookID, imageID, description, height, width, targetImageURL, ARImageURLs, links, title, videoURL):
    books_ref = db.collection(u"books").document(bookID).collection("images").document(imageID)
    image = Image(imageID, description, height, width, targetImageURL, ARImageURLs, links, title, videoURL)
    return books_ref.set(image.to_dict())

def process_books_form(db, bookID, coverURL, chatID, expertID, name, author):
    books_ref = db.collection(u"books").document(bookID)
    book = Book(bookID, coverURL, chatID, expertID, name, author)
    return books_ref.set(book.to_dict())

def get_new_image_id(db, bookID):
    # retuns a string of an integer representing the image
    images = db.collection(u"books").document(bookID).collection("images").get()
    id_list = [int(i.to_dict()['imageID']) for i in images]
    if id_list == []:
        id = 1
    else:
        id = max(id_list) + 1
    return str(id)

DIR_PATH = os.path.dirname(os.path.realpath(__file__))
UPLOAD_FOLDER = 'static/images'
print("UPLOAD_FOLDER: {}".format(UPLOAD_FOLDER))
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])

URL_PREFIX = "http://35.236.74.206"
# URL_PREFIX = "http://127.0.0.1:5000"

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def get_list_from_ids(id_name, form):
    # return the list of links from the html ids using the _number format
    # adds the _number to id_name

    # get the list of image links
    i = 0
    exists = True
    list = []
    while exists:
        string = id_name + "_{}".format(i)
        if string in form.keys():
            list.append(form[string])
            i += 1
        else:
            exists = False
    return list

def content_loader_page(db, all_books):

    complete_form = True
    # if you get a content submission
    if request.method == 'POST':
        book_id = request.form['book_id']
        file = request.files['file']
        # image_url = request.form['image_url']
        image_name = request.form['image_name']
        description = request.form['description']
        image_links = get_list_from_ids("image_link", request.form)
        video_links = get_list_from_ids("video_link", request.form)
        info_links = get_list_from_ids("info_link", request.form)

        # for item in [file.filename, image_name, description, image_links, video_links, info_links]:
        #     if item == "":
        #         complete_form = False

        if complete_form:

            # save the file
            if file and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                file.save(os.path.join(DIR_PATH, UPLOAD_FOLDER, filename))

                # set the image url properly
                image_url = os.path.join(URL_PREFIX, UPLOAD_FOLDER, filename)

                print(type(book_id))
                print(type(image_name))
                print(type(description))
                print(type(image_url))
                print(type(image_links[0]))
                print(type(info_links[0]))
                print(type(image_name))
                print(type(video_links[0]))

                # TODO(ethan): write to the database
                # image_id has to be a string of an int
                image_id = get_new_image_id(db, book_id)
                process_image_form(db,book_id,image_id,description,100.0,100.0,image_url,image_links[0],info_links[0],image_name,video_links[0])

                # display a notification on the site
                flash(image_name + ' uploaded.')
            else:
                flash("Couldn't upload image.")
        else:
            flash("Invalid form. Try again.")

    return render_template('content_loader.html', books=all_books)
