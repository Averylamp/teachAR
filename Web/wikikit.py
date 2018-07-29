import requests
import pprint
import json

class WikiKit: 
    """ Class to scrape summary from Wikipedia given url
        Example Usage:
            wiki = WikiKit("https://en.wikipedia.org/wiki/Guns_N%27_Roses")
            print(wiki.getTitle())
            print(wiki.getContent())
    """
    def __init__(self, dataUrl):
        """ init
        """
        self.baseUrl = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles="
        self.dataUrl = dataUrl
        self.searchUrl = self.baseUrl + self.dataUrl[self.dataUrl.rfind('/') + 1:].replace("_", "%20")
        self.title = ""
        self.content = ""
    def requestJson(self):
        """ returns the json from the url
        """
        return requests.get(self.searchUrl)
    def setProperties(self):
        """ set the properties of the object
        """
        r = self.requestJson()
        json_data = r.json()['query']['pages']
        self.title = json_data[list(json_data.keys())[0]]['title']
        contentList = str(json_data[list(json_data.keys())[0]]['extract']).split(".")
        if len(contentList) < 4:
            self.content = ".".join(str(json_data[list(json_data.keys())[0]]['extract']).split("."))
        else:
            self.content = ".".join(str(json_data[list(json_data.keys())[0]]['extract']).split(".")[:3])
        self.content = ''.join([i if ord(i) < 128 else ' ' for i in self.content])

    def getTitle(self):
        """ returns title
        """
        self.setProperties()
        return self.title
    def getContent(self):
        """ returns content
        """
        self.setProperties()
        return self.content