# = Class: pe_280_mcollective_fix::apply
#
# This class is a wrapper around pe_280_mcollective_fix, for use with the puppet
# apply command. It declares a copy of the Service['pe-mcollective'] resource,
# so that MCollective can be restarted after updating the stomp gem package.
#
# (The standard pe_280_mcollective_fix class expects that the normal
# pe_mcollective module is being applied to every node that has the
# pe-mcollective service running; see
# /opt/puppet/share/puppet/modules/pe_mcollective/manifests/posix.pp for the
# class that normally declares this service resource.)
#
# Again, this is only for use with PE 2.8.0; later versions are not affected.
#
class pe_280_mcollective_fix::apply {
  # Only do things on PE 2.8.0 systems with MCollective.
  if str2bool("${::is_pe}") and $::pe_version == '2.8.0' and $::osfamily != 'windows' {

    include pe_280_mcollective_fix

    service { 'pe-mcollective':
      name    => 'pe-mcollective',
      ensure  => running,
    }
  } else {
    notice("Nothing for ${module_name} to do on this system -- either no PE, no MCollective, or not broken.")
  }
}