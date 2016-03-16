kind: List
apiVersion: v1
items:
<pre>
- kind: ReplicationController
  apiVersion: v1
  metadata:
    labels:
      app: ok-nginx
      version: test1
    name: ok-nginx-app
    namespace: nginxtest
  spec:
    replicas: 3
    selector:
      app: ok-nginx-app
      version: test1
    template:
      metadata:
        labels:
          app: ok-nginx-app
          version: test1
      spec:
        containers:
        - name: ok-nginx-app
          image: daocloud.io/nginx
          imagePullPolicy: Always
          ports:
          - containerPort: 80
            protocol: TCP
- kind: Service
  apiVersion: v1
  metadata:
    labels:
      app: ok-nginx-app
    name: ok-nginx
    namespace: nginxtest
  spec:
    type: NodePort
    ports:
    - port: 80
      targetPort: 80
    selector:
      app: ok-nginx-app
  </pre>
