# = Class: pe_280_mcollective_fix
#
# This class installs a hotfix package for Puppet Enterprise 2.8.0, then
# restarts the pe-mcollective service. This is necessary due to a bug in 2.8.0
# that causes MCollective and live management to not work properly. It is not
# necessary for PE 2.8.1 or later.
#
# == Requires:
#
# The puppetlabs/stdlib module, as included by default in PE.
#
# == Sample usage:
#
# include pe_280_mcollective_fix
#
# Alternately, assign this class to the "default" group in the Puppet Enterprise
# console.
#
class pe_280_mcollective_fix {
  # Only do things on PE 2.8.0 systems with MCollective.
  if str2bool("${::is_pe}") and $::pe_version == '2.8.0' and $::osfamily != 'windows' {

    include pe_280_mcollective_fix::params
    $stomp_source   = $pe_280_mcollective_fix::params::stomp_source
    $stomp_name     = $pe_280_mcollective_fix::params::stomp_name
    $stomp_provider = $pe_280_mcollective_fix::params::stomp_provider
    $stomp_pkg      = $pe_280_mcollective_fix::params::stomp_pkg

    if $stomp_source =~ /FAIL/ {
      fail("${module_name}: Something went wrong, and we couldn't find a package appropriate for this system.")
    }

    file { 'pe-stomp-hotfix-package':
      ensure => file,
      path   => "/tmp/${stomp_pkg}",
      mode   => 0644,
      owner  => 'root',
      source => $stomp_source,
    }

    if $::osfamily == 'solaris' {
      file { 'solaris-adminfile':
        ensure => file,
        path   => "/tmp/pup-stomp-adminfile",
        mode   => 0644,
        owner  => 'root',
        source => 'puppet:///modules/pe_280_mcollective_fix/solaris/pup-stomp-adminfile',
      }
      exec { 'pe-stomp-hotfix':
        command => "gzip -dc /tmp/${stomp_pkg} | pkgadd -G -a /tmp/pup-stomp-adminfile -n -d /dev/stdin all",
        unless  => "pkginfo -l PUPstomp | grep -i version | grep '1\.2\.3-1\.1\.9' > /dev/null",
        user    => root,
        require => [ File['pe-stomp-hotfix-package'], File['solaris-adminfile'] ],
        notify  => Service['pe-mcollective'],
        path    => "/usr/sbin:/usr/bin",
      }
    }
    else {
      package { 'pe-stomp-hotfix':
        name     => $stomp_name,
        ensure   => latest,
        provider => $stomp_provider,
        source   => "/tmp/${stomp_pkg}",
        require  => File['pe-stomp-hotfix-package'],
        notify   => Service['pe-mcollective'],
      }
    }

  } else {
    notice("Nothing for ${module_name} to do on this system -- either no PE, no MCollective, or not broken.")
  }
}

