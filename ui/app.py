import datetime
import json
import boto3
from botocore.exceptions import ClientError

from chalice import Chalice, NotFoundError, BadRequestError

app = Chalice(app_name='demobackend')
app.debug = True

BUCKET='Your R-W s3 bucket'
UUID='anything random so runs dont clobber each other'

class Nodes:

  def __init__(self, demo_id=UUID, body=''):

     self.s3 = boto3.client('s3')
     self.demo_id = demo_id
     self.Key = f'{self.demo_id}/nodes.json'

     self.raw = body
     self.items: List = self.raw.get('items', [])

     self.minions: List = [item for item in self.items if ('node-role.kubernetes.io/master' not in item.get('metadata', []).get('labels'))]
     self.masters: List = [item for item in self.items if ('node-role.kubernetes.io/master' in item.get('metadata', []).get('labels'))]

     self.schedule = [item for item in self.items if ('NoSchedule' not in next(iter(item.get('spec', {}).get('taints', [])), {}).get('effect', ''))]
     self.capacity = [c.get('status', {}).get('capacity', {}) for c in self.schedule]
     self.cpu = sum([int(c.get('cpu', 0)) for c in self.capacity])
     self.memory = int(sum([int(ram.get('memory', '')[:-2]) for ram in self.capacity]) / 1000_000)


  @property
  def metadata(self):

    master = next(iter(self.masters), {})
    minion = next(iter(self.minions), {})

    return {
            'Masters': { 'size': len(self.masters), 'type': master.get('metadata', {}).get('labels').get('beta.kubernetes.io/instance-type') },
            'Minions': { 'size': len(self.minions), 'type': minion.get('metadata', {}).get('labels').get('beta.kubernetes.io/instance-type') },
            'Provider': master.get('spec', {}).get('providerID', 'Unknown').split(':')[0],
            'RAM': f'{self.memory}GB',
            'vcpu': self.cpu,
            'storage': '0GB',
           }


@app.route('/')
def index():
    return 'cncfdemo'

@app.route('/{demo_id}/events/{event}', methods=['GET', 'PUT', 'POST'])
def steps(demo_id, event):

  request = app.current_request
  parsed = event.split('-')

  try:
    index, title = int(parsed[0]), ' '.join(parsed[1:])
  except Exception as e:
    raise BadRequestError('bad event title')

  s3 = boto3.client('s3')

  try:
    response = s3.get_object(Bucket=BUCKET, Key=f'{demo_id}/events.json')
    body = json.loads(response['Body'].read())
  except ClientError as e:
    now = datetime.datetime.utcnow()
    human = now.strftime('%a, %d %b %Y - %H:%M UTC')
    message = f'Demo Started On {human}'
    body = dict(events = [{'raw': f'<span class="event-message">{message}</span>', 'title': ''}])

  if index >= len(body['events']):
    body['events'].extend([{}]*(index))

  body['events'][index] = body['events'][index] or dict(title = title)

  if body['events'][index].get('timestart'):
    body['events'][index]['timeend'] = int(datetime.datetime.utcnow().timestamp())
  else:
    body['events'][index]['timestart'] = int(datetime.datetime.utcnow().timestamp())

  try:
    content = request.json_body.get('content')
  except:
    content = None

  if content:
    body['events'][index]['content'] = content
  else:
    body['events'][index]['stdout_url'] = f'{BUCKET}/{demo_id}/events/{event}.stdout'
    s3.put_object(Bucket=BUCKET, Key=f'{demo_id}/events/{event}.stdout', Body=request.raw_body, ACL='public-read', ContentType='text/plain')

  s3.put_object(Bucket=BUCKET, Key=f'{demo_id}/events.json', Body=json.dumps(body), ACL='public-read', ContentType='text/plain')

  return 'cncfdemo'

@app.route('/{demo_id}/nodes', methods=['GET', 'PUT', 'POST'])
def nodes(demo_id):

  request = app.current_request

  if request.method in ('PUT', 'POST'):
    nodes = Nodes(demo_id=UUID, body=request.json_body)
    metadata = json.dumps(nodes.metadata)

    s3.put_object(Bucket=BUCKET, Key=f'{demo_id}/metadata.json', Body=metadata, ACL='public-read', ContentType='text/plain')
    return metadata

  return '''
          endpoint=api.cncfdemo.io
          dID=klRnX69
          { kubectl get nodes -o json } 2>&1 | tee /tmp/nodes
          curl -s --output /dev/null --request POST --include --data-binary @/tmp/nodes --no-buffer ${endpoint}/${dID}/nodes'''


@app.route('/{demo_id}/shutdown')
def shutdown(demo_id):
  try:
    response = s3.get_object(Bucket=BUCKET, Key=f'{demo_id}/metadata.json')
    body = json.loads(response['Body'].read())
    body['timeend'] = int(datetime.datetime.utcnow().timestamp())
    s3.put_object(Bucket=BUCKET, Key=f'{demo_id}/metadata.json', Body=body, ACL='public-read', ContentType='text/plain')
    return 'OK'
  except:
    return 'too early'
