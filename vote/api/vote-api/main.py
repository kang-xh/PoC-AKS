from flask import Flask, request, render_template
import os
import random
import redis
import socket
import sys

app = Flask(__name__)


# Redis configurations
redis_server = os.environ['REDIS']

# Redis Connection
try:
    if "REDIS_PWD" in os.environ:
        r = redis.StrictRedis(host=redis_server,
                        port=6379,
                        password=os.environ['REDIS_PWD'])
    else:
        r = redis.Redis(redis_server)
    r.ping()
except redis.ConnectionError:
    exit('Failed to connect to Redis, terminating.')

@app.route('/api/votes', methods=['GET'])
def get_votes():
    return "Mock API Entry: GET /api/votes"
  
if __name__ == "__main__":
    app.run()
