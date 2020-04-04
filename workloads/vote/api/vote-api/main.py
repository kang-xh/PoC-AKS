from flask import Flask

app = Flask(__name__)

@app.route('/', methods=['GET'])
def get_votes():
    return "Thanks for visit, please access API interface /api/votes"

@app.route('/api/votes', methods=['GET'])
def get_vote():
    return "Mock API Entry: GET /api/votes"

@app.route('/api/votes', methods=['POST'])
def post_votes():
    return "Mock API Entry: POST /api/votes"

@app.route('/api/votes', methods=['PUT'])
def put():
    return "Mock API Entry: PUT /api/votes"

@app.route('/api/votes', methods=['PATCH'])
def patch_vote():
    return "Mock API Entry: PATCH /api/votes"

@app.route('/api/votes', methods=['DELETE'])
def delete_votes():
    return "Mock API Entry: DELETE /api/votes"

if __name__ == "__main__":
    app.run()
