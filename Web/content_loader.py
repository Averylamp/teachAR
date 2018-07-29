from flask import Flask, render_template, flash, request
from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField

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

    # get the current books names
    # current_books =
    print(all_books)

    complete_form = True
    # if you get a content submission
    if request.method == 'POST':
        image_url = request.form['image_url']
        image_name = request.form['image_name']
        description = request.form['description']
        image_links = get_list_from_ids("image_link", request.form)
        video_links = get_list_from_ids("video_link", request.form)
        info_links = get_list_from_ids("info_link", request.form)

        print(image_url)
        print(image_name)
        print(description)
        print(image_links)
        print(video_links)
        print(info_links)

        for item in [image_url, image_name, description, image_links, video_links, info_links]:
            if item == "":
                complete_form = False

        if complete_form:
            # display a notification on the site
            flash(image_name + ' uploaded.')

            # put data in the database if correct
        else:
            flash("Invalid form. Try again.")

    return render_template('content_loader.html')
