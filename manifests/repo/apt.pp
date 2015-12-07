# install the APT repo + key for the given distro
class logentries::repo::apt {
  apt::key {'FA7FA2E59A243096E1B4105DA5270289C43C79AD':
    ensure      => present,
    key_content => $logentries::repo::key,
  }
  apt::source { 'logentries':
    location    => 'http://rep.logentries.com/',
    release     => $::lsbdistcodename,
    repos       => 'main',
    key         => 'FA7FA2E59A243096E1B4105DA5270289C43C79AD',
    comment     => 'logentries.com client repo, deployed by puppet module logentries',
    # FIXME: puppet 2.7 backward compatibility, deprecated
    include_src => false,
    require     => Apt::Key['FA7FA2E59A243096E1B4105DA5270289C43C79AD'],
    before      => [Package['logentries-daemon'], Package['logentries']],
  }
}
