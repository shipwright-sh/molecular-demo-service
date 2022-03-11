(import "api/api.libsonnet") +
{
  api+: {
    deployment+: {
      spec+: {
        replicas: 3
      }
    }
  }
}