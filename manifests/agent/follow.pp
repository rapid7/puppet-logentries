# follow a given logfile
define logentries::agent::follow(
  $path = '',
  $token = '',
  $destination = '',
  $multi_line_start_pattern = '',
) {
  include logentries::agent

  # use title as path if there's no path argument
  if $path == '' {
    $my_path = $title
  } else {
    $my_path = $path
  }

  # convert filename/title to something that can be a filename in any case
  # colissions should be rare
  $clean_title = regsubst($title, '[^0-9A-Za-z.\-]', '_', 'G')
  $confd_path = "/etc/le/conf.d/${clean_title}"

  if $logentries::params::use_server_config == true {
    if $token != '' {
      fail 'can not use tokens with server_side_config=true'
    }
    exec { "/usr/bin/le follow ${my_path} --name=${title}":
      command => "/usr/bin/le follow '${my_path}' --name='${title}' && touch ${confd_path}.followed",
      creates => "${confd_path}.followed",
      require => Package['logentries-daemon'],
    }
  } else {
    if $token == '' and $destination == '' {
      $token_or_destination = "destination = ${::hostname}${my_path}"
    } elsif $token == '' {
      # FIXME: maybe make sure there's a / in there?
      $token_or_destination = "destination = ${destination}"
    } elsif $destination == '' {
      # FIXME: token should be regex checked
      $token_or_destination = "token = ${token}"
    } else {
      fail 'can not specify both, token and destination'
    }
    
    if $multi_line_start_pattern != '' {
      $entry_identifier = "entry_identifier = ${multi_line_start_pattern}"
    }

    file { "${confd_path}.conf":
      content => "# managed by puppet, module ${::module}\n[${clean_title}]\npath = ${my_path}\n${token_or_destination}\n${entry_identifier}\n",
      require => File['/etc/le/conf.d'],
      notify  => Service['logentries'],
    }
  }
}
