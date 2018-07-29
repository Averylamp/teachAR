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
    def __init__(self, imageID, description, height, width, textbookImageURL, ARImageURLs, links, title, videoURLs):
        self.imageID = imageID
        self.description = description
        self.height = height
        self.width = width
        self.textbookImageURL = textbookImageURL
        self.ARImageURls = ARImageURLs
        self.links = links
        self.title = title
        self.videoURLs = videoURLs

    def to_dict(self):
        return vars(self)
