#!/bin/bash

PULL_REQUEST=$1

if [[ -z "$PULL_REQUEST" ]]; then
  echo "Incorrect tag"
  exit 1
fi

PULL_REQUEST=$PULL_REQUEST

echo $PULL_REQUEST

docker build -t "localhost:5000/k8s-multi:${PULL_REQUEST}" .
docker push "localhost:5000/k8s-multi:${PULL_REQUEST}"


sed -e "s/%pullRequest%/${PULL_REQUEST}/g" kubernetes/deployment.yaml > kubernetes/build/deployment.yaml
sed -e "s/%pullRequest%/${PULL_REQUEST}/g" kubernetes/service.yaml > kubernetes/build/service.yaml
sed -e "s/%pullRequest%/${PULL_REQUEST}/g" kubernetes/ingress.yaml > kubernetes/build/ingress.yaml

kubectl apply -f kubernetes/build
kubectl rollout restart deploy api-deployment-${PULL_REQUEST}
