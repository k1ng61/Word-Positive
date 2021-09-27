# uses bert sent2vec to find similarity between sentence and definitions
from PyDictionary import PyDictionary
from scipy import spatial
from sent2vec.vectorizer import Vectorizer
from flask import Flask, request

dict = PyDictionary()

def getDefinition(word, sentence):
    # sentence = "The novel is written from personal experience"
    # word = "novel"

    meaning = dict.meaning(word)
    definitions = [sentence]

    for value in meaning.values():
        for v in value:
            definitions.append(v)

    vectorizer = Vectorizer()
    vectorizer.bert(definitions)
    vectors_bert = vectorizer.vectors

    dists = []
    for i in range(len(definitions) - 1):
        dist_1 = spatial.distance.cosine(vectors_bert[0], vectors_bert[i + 1])
        dists.append(dist_1)

    best_definition = max(dists)
    best_definition = dists.index(best_definition)
    best_definition = definitions[best_definition + 1]

    return best_definition

app = Flask(__name__)

@app.route("/definition")
def definition():
    word = request.args.get('word')
    sentence = request.args.get('sentence')
    return getDefinition(word, sentence)

if __name__ == "__main__":
    app.run()

