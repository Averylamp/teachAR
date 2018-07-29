from flask import Flask, render_template, flash, request
from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField

# App config.
DEBUG = True
app = Flask(__name__)
app.config.from_object(__name__)
app.config['SECRET_KEY'] = '7d441f27d441f27567d441f2b6176a'

class ReusableForm(Form):
    name = TextField('Name:', validators=[validators.required()])

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

@app.route("/", methods=['GET', 'POST'])
def hello():
    form = ReusableForm(request.form)
    if form.errors != {}:
        print(form.errors)

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

        # display a notification on the site
        flash(image_name + ' uploaded.')

    return render_template('content_loader.html', form=form)

if __name__ == "__main__":
    app.run(debug=True)
