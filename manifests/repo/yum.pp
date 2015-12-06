# install the yum repo + key for the given distro
class logentries::repo::yum ($baseurl) {
  yumrepo {'logentries':
    descr    => 'logentries.com client repo, deployed by puppet module logentries',
    enabled  => 1,
    gpgcheck => 1,
    # FIXME: find out what the best practice is for supplying the key directly
    gpgkey   => $logentries::repo::key_url,
    baseurl  => $baseurl,
    before   => [Package['logentries-daemon'], Package['logentries']],
  }
}