from flask import Flask, render_template, flash, request
from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField
from werkzeug.utils import secure_filename
import os

DIR_PATH = os.path.dirname(os.path.realpath(__file__))
UPLOAD_FOLDER = 'static/uploaded_images'
print("UPLOAD_FOLDER: {}".format(UPLOAD_FOLDER))
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])

URL_PREFIX = "https://35.236.74.206/"

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

    # make name to book id dictionary
    book_name_to_id = {}
    for book in all_books:
        book_name_to_id[book['name']] = book['bookID']
    print(book_name_to_id)
    # book_name_to_id = []
    # for book in all_books:
    #     book_name_to_id[book['name']] = book['bookID']
    # print(book_name_to_id)

    complete_form = True
    # if you get a content submission
    if request.method == 'POST':
        book_id = request.form['book_id']
        print(book_id)
        file = request.files['file']
        # image_url = request.form['image_url']
        image_name = request.form['image_name']
        description = request.form['description']
        image_links = get_list_from_ids("image_link", request.form)
        video_links = get_list_from_ids("video_link", request.form)
        info_links = get_list_from_ids("info_link", request.form)

        # print(image_url)
        print(image_name)
        print(description)
        print(image_links)
        print(video_links)
        print(info_links)

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

                # TODO(ethan): write to the database


                # display a notification on the site
                flash(image_name + ' uploaded.')
            else:
                flash("Couldn't upload image.")
        else:
            flash("Invalid form. Try again.")

    return render_template('content_loader.html', books=all_books)
