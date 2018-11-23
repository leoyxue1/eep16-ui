from flask import Flask, render_template, request
from elasticsearch import Elasticsearch
import pandas as pd

app = Flask(__name__)
es = Elasticsearch(['http://192.168.64.6:9200'])
es_index="eep16"


@app.route('/')
def home():
    return render_template('search.html')


@app.route('/search/results', methods=['GET', 'POST'])
def search_request():
    # read this to implement SSL if required:  https://elasticsearch-py.readthedocs.io/en/master/
    # at the moment, for simplicity, we use http first
    search_term = request.form["input"]
    res = es.search(
        index=es_index,
        size=20,

        body={
            "query": {
                "simple_query_string": {
                    "query": search_term,
                    "fields": ["content"],
                    "default_operator": "and",
                    "analyze_wildcard": True
                }
            },
            "highlight": {
                "number_of_fragments": 3,
                "fragment_size": 150,
                "fields": {
                    "content": {
                        "pre_tags": "<b>",
                        "post_tags": "</b>"
                    }
                }
            }
        }
    )
    res_count = res['hits']['total']
    # if res_count=0, it should avoid the following pandas operations, instead, give a null dict to the result
    df = pd.DataFrame(res['hits']['hits'])
    if res_count > 0:
        df = pd.concat([df.drop(['_source'], axis=1), df['_source'].apply(pd.Series)], axis=1)
        df = pd.concat([df, df["content"].str.slice(600,900).rename("short_content")], axis=1)
    output = df.T.to_dict()

    return render_template('results.html', res=output, res_count=res_count)


if __name__ == "__main__":
    app.run(host='127.0.0.1', port=8999, threaded=True, debug=True)