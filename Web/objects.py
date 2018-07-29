class Book(object):
    def __init__(self, bookID, coverURL, chatID, expertID, name, author):
        self.bookID = bookID
        self.chatID = chatID
        self.coverURL = coverURL
        self.expertID = expertID
        self.name = name
        self.author = author

    def to_dict(self):
        return vars(self)


class Image(object):
    def __init__(self, imageID, description, height, width, textbookImageURL, ARImageURL, links, title, videoURL):
        self.imageID = imageID
        self.description = description
        self.height = height
        self.width = width
        self.targetImageURL = textbookImageURL if textbookImageURL is not "" else "http://sloths.mit.edu/image/0.jpg"
        self.ARImageURL = ARImageURL if ARImageURL is not "" else "http://sloths.mit.edu/image/0.jpg"
        self.links = links if links is not "" else "http://sloths.mit.edu/image/0.jpg"
        self.title = title
        self.videoURL = videoURL if links is not "" else "http://sloths.mit.edu/video/0.mp4"

    def to_dict(self):
        return vars(self)
