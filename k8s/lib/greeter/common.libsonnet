local k = import 'ksonnet-util/kausal.libsonnet';
{
  namespace:
    k.core.v1.namespace.new($._config.namespace),
}