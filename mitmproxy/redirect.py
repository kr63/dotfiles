from mitmproxy import http
import re

exclude = [
    'http://ktda-dev.test.gosuslugi.ru/catalog/repository/rest/inq/list'
]
patterns = [
    'http://ktda-dev.test.gosuslugi.ru/catalog/repository',
    'http://127.0.0.1:8080/repository',

    # 'http://ktda-dev.test.gosuslugi.ru/catalog/core/rest/doc/updateStatus',
    # 'http://127.0.0.1:8090/core/rest/doc/updateStatus',

    'http://ktda-dev.test.gosuslugi.ru/catalog/core',
    'http://127.0.0.1:8090/core',
    
    'wrong_link'
]
patterns = dict(zip(patterns[::2], patterns[1::2]))


def request(flow: http.HTTPFlow) -> None:

    if flow.request.pretty_url not in exclude:
        for pattern in patterns.keys():
            if re.match(pattern, flow.request.pretty_url):
                flow.request.url = re.sub(pattern, patterns[pattern], flow.request.pretty_url)

