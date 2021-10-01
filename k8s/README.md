# Spark operator
   * https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/tree/spark-operator-chart-1.1.6

```commandline
helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator
```

```commandline
helm install my-release spark-operator/spark-operator --namespace spark-operator --create-namespace
```

# Spark
   * https://spark.apache.org/docs/latest/running-on-kubernetes.html#submitting-applications-to-kubernetes