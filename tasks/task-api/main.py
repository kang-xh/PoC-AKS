#!flask/bin/python
# https://www.cnblogs.com/vovlie/p/4178077.html
from flask import Flask, jsonify, abort, make_response, request, url_for

app = Flask(__name__)

tasks = [
    {
        'id': 1,
        'title': u'Update ADO',
        'description': u'update ado with newest project progress', 
        'done': False
    },
    {
        'id': 2,
        'title': u'Running',
        'description': u'12KM/Hour, 1 hour every day', 
        'done': False
    }
]
@app.route('/')
def index():
    return "Thanks for visit, please call /api/tasks! \n"

@app.route('/api/tasks', methods=['GET'])
def get_tasks():
    return jsonify({'tasks': tasks})

@app.route('/api/tasks/<int:task_id>', methods=['GET'])
def get_task(task_id):
    task = list(filter(lambda t: t['id'] == task_id, tasks))
    if len(task) == 0:
        abort(404)
    return jsonify({'task': task[0]})

@app.route('/api/tasks', methods=['POST'])
def create_task():
    if not request.json or not 'title' in request.json:
        abort(400)
    task = {
        'id': tasks[-1]['id'] + 1,
        'title': request.json['title'],
        'description': request.json.get('description', ""),
        'done': False
    }
    tasks.append(task)
    return jsonify({'task': task}), 201

@app.route('/api/tasks/<int:task_id>', methods=['PUT'])
def update_task(task_id):
    task = list(filter(lambda t: t['id'] == task_id, tasks))
    if len(task) == 0:
        abort(404)
    if not request.json:
        abort(400)
    if 'title' in request.json:
        abort(400)
    if 'description' in request.json:
        abort(400)
    if 'done' in request.json and type(request.json['done']) is not bool:
        abort(400)
    task[0]['title'] = request.json.get('title', task[0]['title'])
    task[0]['description'] = request.json.get('description', task[0]['description'])
    task[0]['done'] = request.json.get('done', task[0]['done'])
    return jsonify({'task': task[0]})

@app.route('/api/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    task = list(filter(lambda t: t['id'] == task_id, tasks))
    if len(task) == 0:
        abort(404)
    tasks.remove(task[0])
    return jsonify({'result': True})


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Invalid Inut, Item Not found'}), 404)

if __name__ == '__main__':
    app.run()
