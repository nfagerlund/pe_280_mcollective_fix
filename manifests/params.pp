class pe_280_mcollective_fix::params {
  $source_base = "puppet:///modules/${module_name}"

  # Set the following variables based on the operating system:
  #   $stomp_provider
  #   $stomp_name
  #   $stomp_source
  #
  case $::osfamily {
    'redhat': {
      $stomp_provider = 'rpm'
      case $::operatingsystemrelease {
        /^5/: {
          $stomp_name   = 'pe-rubygem-stomp-1.2.3-1.1.9.pe.el5.noarch.rpm'
          $stomp_source = "${source_base}/el/${stomp_name}"

          package { 'pe-rubygem-stomp-doc-1.2.3-1.1.9.pe.el5.noarch.rpm':
            ensure   => installed,
            provider => rpm,
            source   => "${source_base}/el/pe-rubygem-stomp-doc-1.2.3-1.1.9.pe.el6.noarch.rpm",
          }
        }
        /^6/: {
          $stomp_name   = 'pe-rubygem-stomp-1.2.3-1.1.9.pe.el6.noarch.rpm'
          $stomp_source = "${source_base}/el/${stomp_name}"

          package { 'pe-rubygem-stomp-doc-1.2.3-1.1.9.pe.el6.noarch.rpm':
            ensure   => installed,
            provider => rpm,
            source   => "${source_base}/el/pe-rubygem-stomp-doc-1.2.3-1.1.9.pe.el6.noarch.rpm",
          }
        }
        default: {
          $stomp_source = 'FAIL'
        }
      }
    }
    'suse': {
      $stomp_provider = 'rpm'
      $stomp_name     = 'pe-rubygem-stomp-1.2.3-1.1.9.pe.noarch.rpm'
      $stomp_source   = "${source_base}/sles/${stomp_name}"

      package { 'pe-rubygem-stomp-doc-1.2.3-1.1.9.pe.noarch.rpm':
        ensure   => installed,
        provider => rpm,
        source   => "${source_base}/suse/pe-rubygem-stomp-doc-1.2.3-1.1.9.pe.noarch.rpm",
      }
    }
    'debian': {
      $stomp_provider = 'dpkg'
      $stomp_name     = 'pe-rubygem-stomp_1.2.3-1puppet1.1.9_all.deb'

      $packagedir = $::operatingsystem ? {
        'debian'    => 'debian/squeeze',
        'ubuntu'    => $::operatingsystemrelease ? {
          /^12\.04/ => 'ubuntu/precise',
          /^10\.04/ => 'ubuntu/lucid',
        },
        default     => 'FAIL',
      }

      $stomp_source = "${source_base}/${packagedir}/${stomp_name}"
    }
    'solaris': {
      $stomp_provider = 'sun'
      $stomp_name     = $::hardwareisa ? {
        /^i\d86/ => 'pup-stomp-1.2.3-1.1.9.i386.pkg.gz',
        'sparc'  => 'pup-stomp-1.2.3-1.1.9.sparc.pkg.gz',
        default  => 'FAIL',
      }
      $stomp_source = "${source_base}/solaris/${stomp_name}"
    }
    'aix': {
      $stomp_provider = 'rpm'
      $stomp_name = $::operatingsystemrelease ? { # formatted like 7300-XX-X.......
        /^5/ => 'pe-rubygem-stomp-1.2.3-1.1.9.pe.aix5.3.noarch.rpm',
        /^6/ => 'pe-rubygem-stomp-1.2.3-1.1.9.pe.aix6.1.noarch.rpm',
        /^7/ => 'pe-rubygem-stomp-1.2.3-1.1.9.pe.aix7.1.noarch.rpm',
        default => 'FAIL'
      }
      $stomp_source = "${source_base}/aix/${stomp_name}"
    }
    default: {
      $stomp_source = 'FAIL'
    }
  }
}

