class pe_280_mcollective_fix {
  # Only do things on PE 2.8.0 systems with MCollective.
  if str2bool("${::is_pe}") and $::pe_version == '2.8.0' and $::osfamily != 'windows' {

    include pe_280_mcollective_fix::params
    $stomp_source   = $pe_280_mcollective_fix::params::stomp_source
    $stomp_name     = $pe_280_mcollective_fix::params::stomp_name
    $stomp_provider = $pe_280_mcollective_fix::params::stomp_provider

    if $stomp_source =~ /FAIL/ {
      fail("${module_name}: Something went wrong, and we couldn't find a package appropriate for this system.")
    }

    file { 'pe-stomp-hotfix-package':
      ensure => file,
      path   => "/tmp/${stomp_name}",
      mode   => 0644,
      owner  => 'root',
      source => $stomp_source,
    }

    package { 'pe-stomp-hotfix':
      name     => $stomp_name,
      ensure   => installed,
      provider => $stomp_provider,
      source   => "/tmp/${stomp_name}",
      require  => File['pe-stomp-hotfix-package'],
      notify   => Service['pe-mcollective'],
    }

  } else {
    notice("Nothing for ${module_name} to do on this system -- either no PE, no MCollective, or not broken.")
  }
}

