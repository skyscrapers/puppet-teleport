# == Define: teleport::trusted_cluster
#
define teleport::trusted_cluster (
  $enabled        = true,
  $token          = undef,
  $tunnel_addr    = undef,
  $web_proxy_addr = undef,
) {
  if ! defined(Class['teleport']) {
    fail('You must include the teleport base class before using the trusted_cluster defined resource')
  }

  validate_bool($enabled)
  validate_string($token)
  validate_string($tunnel_addr)
  validate_string($web_proxy_addr)

  file { "/etc/teleport_trusted_cluster_${name}.yaml":
    ensure  => file,
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => template('teleport/trusted_cluster.yaml.erb'),
  } ~>
  exec { "create_teleport_trusted_cluster_${name}":
    command     => "${teleport::bin_dir}/tctl create -f /etc/teleport_trusted_cluster_${name}.yaml",
    refreshonly => true,
    require     => Class['teleport::install']
  }
}
