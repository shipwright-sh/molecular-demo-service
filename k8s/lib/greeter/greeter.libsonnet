local k = import "ksonnet-util/kausal.libsonnet";

(import "config.libsonnet") +
{
  local deployment = k.apps.v1.deployment,
  local container = k.core.v1.container,
  local port = k.core.v1.containerPort,

  greeter_container::
    container.new('greeter', $._images.greeter) +
    container.withPorts([port.new('greeter', $._config.port)]) +
    container.withEnvMap({
      'SERVICEDIR': 'services',
      'SERVICE': 'greeter',
    }) +
    k.util.resourcesRequests('100m', '500Mi') +
    k.util.resourcesLimits('200m', '1Gi'),

  greeter_deployment:
    deployment.new('greeter', 1, [$.greeter_container]),

  service: k.util.serviceFor($.greeter_deployment),
}