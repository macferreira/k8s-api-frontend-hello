# k8s api frontend hello world

### Installation

Install [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
To use the Web Ui (Dashboard) check installation [here](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)

Start minikube and enable heapster and metrics-server.
```sh
$ minikube start
$ minikube addons enable heapster
$ minikube addons enable metrics-server
```

To access the web Ui:
```sh
$ minikube dashboard
```

To access heapster metrics
```sh
$ minikube addons open heapster
```

To start the application:
```sh
$ ./create_application.sh
```

You should now have the app running in 2 namespaces (production and staging), to check the ip of the frontend:
```sh
$ minikube service frontend --url --namespace=production
$ minikube service frontend --url --namespace=staging
```

To test the autoscaling open some terminals and start some busybox images (autoscaling is only enabled for production):
```sh
$ kubectl run -i --tty load-generator-1 --image=busybox /bin/sh --namespace=production
```
```sh
$ kubectl run -i --tty load-generator-2 --image=busybox /bin/sh --namespace=production
```
```sh
$ kubectl run -i --tty load-generator-3 --image=busybox /bin/sh --namespace=production
```
```sh
$ kubectl run -i --tty load-generator-4 --image=busybox /bin/sh --namespace=production
```

Let's stress the app a bit, inside each busybox:
```sh
$ while true; do wget -q -O- http://frontend.production.svc.cluster.local; done
```

To deploy a single image to the app:
```sh
$ ./deploy_image.sh production frontend 1.0
```