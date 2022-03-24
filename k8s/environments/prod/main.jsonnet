(import "greeter/api.libsonnet") +
{
  greeter_deployment+: {
    spec+: {
      replicas: 3
    }
  }
}