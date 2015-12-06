# thank you Stefan Jenkner!
# http://jenkner.org/blog/2013/03/27/use-osfamily-instead-of-operatingsystem/
class logentries::helpers::oldfacter {
  if ! $::osfamily {
    case $::operatingsystem {
      'RedHat', 'Fedora', 'CentOS', 'Scientific', 'SLC',
      'Ascendos', 'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL': {
        $osfamily = 'RedHat'
      }
      'ubuntu', 'debian': {
        $osfamily = 'Debian'
      }
      'SLES', 'SLED', 'OpenSuSE', 'SuSE': {
        $osfamily = 'Suse'
      }
      'Solaris', 'Nexenta': {
        $osfamily = 'Solaris'
      }
      default: {
        $osfamily = $::operatingsystem
      }
    }
  }
}
