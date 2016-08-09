# check & set up configuration, and if desired, also the repo
class logentries (
  $account_key,
  $agent_key = '',
  $datahub = '',
  $register = true,
  $use_server_config = false,
  $manage_repos = true
) {
  if $account_key !~
    /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/ {
    fail "${account_key} argument doesn't look right"
  }
  if $agent_key != '' and $agent_key !~
    /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/ {
    fail "${agent_key} argument doesn't look right"
  }
  class {'logentries::params':
    account_key       => $account_key,
    agent_key         => $agent_key,
    datahub           => $datahub,
    use_server_config => $use_server_config,
    register          => $register, 
  }
  if $manage_repos {
    include logentries::repo
  }
}
