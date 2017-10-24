From within this directory:

- `pip install chalice`
- `chalice deploy`

Make note of the resulting endpoint, specify in future runs with `-e CNCFDEMO_ENDPOINT`.

``` bash
export GOOGLE_CREDENTIALS=$(cat ~/credentials-gce.json)
docker run \
  -v /tmp/data:/cncf/data  \
  -e NAME=cross-cloud  \
  -e CLOUD=gce    \
  -e COMMAND=deploy  \
  -e BACKEND=file  \
  -e CNCFDEMO_ID=$CNCFDEMO_ID \
  -e CNCFDEMO_ENDPOINT=$CNCFDEMO_ENDPOINT \
  -e GOOGLE_REGION=us-central1    \
  -e GOOGLE_PROJECT=test-cncf-cross-cloud  \
  -e GOOGLE_CREDENTIALS=”${GOOGLE_CREDENTIALS}”
  -ti registry.cncf.ci/cncf/cross-cloud/provisioning:ci-stable-v0-2-0
```

http POST $endpoint/$UUID/events/01-Creating-Cloud-Resources 

Transforms into:
 - $BUCKET/events/event/01-Creating-Cloud-Resources.stdout (raw output from terminal)
 - $BUCKET/events/events.json (denormalized list of events with timings)

Additonally `kubectl get nodes -o json | http POST $endpoint/$UUID/nodes` results in:
 - $BUCKET/$UUID/metadata.json (parsed out aggregates of cluster capacity and metadata)

