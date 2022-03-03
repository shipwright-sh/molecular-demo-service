local k = import "ksonnet-util/kausal.libsonnet";

(import "config.libsonnet") +
{
  local deployment = k.apps.v1.deployment,
  local container = k.core.v1.container,
  local port = k.core.v1.containerPort,
  local service = k.core.v1.service,

  api: {
    deployment: deployment.new(
      name=$._config.api.name, replicas=1,
      containers=[
        container.new($._config.api.name, $._image.api) +
        container.withPorts([port.new("api", $._config.api.port)]) +
        container.resources.withLimits({
          memory: "1G", cpu: "20m"
        }) +
        container.resources.withRequests({
            memory: "1G", cpu: "10m"
        }),
      ],
    ),
    service: k.util.serviceFor(self.deployment),
  },
}