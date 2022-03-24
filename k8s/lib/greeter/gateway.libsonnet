local k = import "ksonnet-util/kausal.libsonnet";

(import "config.libsonnet") +
{
  local deployment = k.apps.v1.deployment,
  local container = k.core.v1.container,
  local port = k.core.v1.containerPort,
  local ingress = k.networking.v1.ingress,
  local ingressRule = k.networking.v1.ingressRule,
  local httpIngressPath = k.networking.v1.httpIngressPath,
  local ingressTLS = k.networking.v1.ingressTLS,

  gateway_container::
    container.new('gateway', $._images.greeter) +
    container.withPorts([port.new('gateway', $._config.port)]) +
    container.withEnvMap({
      'SERVICEDIR': 'services',
      'SERVICE': 'greeter',
    }) +
    k.util.resourcesRequests('100m', '500Mi') +
    k.util.resourcesLimits('200m', '1Gi'),

  gateway_deployment:
    deployment.new('gateway', 1, [$.gateway_container]),

  gateway_service: k.util.serviceFor($.gateway_deployment),

  gateway_ingress: 
    ingress.new('gateway') +
    ingress.spec.withIngressClassName('kong') +
    ingress.spec.withRules(
      ingressRule.withHost('gateway.example.com') +
      ingressRule.http.withPaths(
        httpIngressPath.withPath('/') +
        httpIngressPath.withPathType('Prefix') +
        httpIngressPath.backend.service.withName('gateway') +
        httpIngressPath.backend.service.port.withName($.service.metadata.name)
      ),
    ) +
    if $._config.tls_enabled then
    ingress.spec.withTls(
      ingressTLS.withHosts('greeter-api-gateway.example.com') +
      ingressTLS.withSecretName('tls-greeter-api-gateway')
    )else {},
}