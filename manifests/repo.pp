# Install the correct repository for the current OS/architecture
class logentries::repo {
  $key = "-----BEGIN PGP PUBLIC KEY BLOCK-----\nVersion: GnuPG v1.4.11 (GNU/Linux)\n\nmQENBE16w8YBCAC0U7hdeaZ99rZtTa81Au8bQPbDh016FvLSRom8gvUSLiAzPtAE\nF+xQE04hALWIMGUBaYdq0HVPa05k0shf5aOCJabmQaBNJdKtSC5Uj3VTA00NHTIs\n5ZIjrIngSzNvgPVBcAfNwQuPLHbQl2O1b7T6jR6p+W5a0tBuWnM+4/k+JelUc4t1\ndSehytant2SovIwtRLFY+hsnkrEVr4Rqbg3mwzc8itJJulGlR9+I7025KWIDzZfi\nkGjbCkbXmToewWa2smSzGLMr0s1y+AV36WO/qIFTeDEWhwmKTopXXCi3WrRIlXJz\nyQJ0e4Umt5WUxoUrw30xP/O2eH+V+YjU5lSzABEBAAG0LExvZ2VudHJpZXMgUmVs\nZWFzZSBLZXkgPGluZm9AbG9nZW50cmllcy5jb20+iQE+BBMBAgAoBQJNesPGAhsD\nBQkJZgGABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRClJwKJxDx5rQXFB/sH\npp7lzgq81VMtmMd5Fc1mdghHqq0h+ePPDYcFUSPKxMq6blH2D1AA7Jq97f6YMS+y\nk/GPXTZRse+zbRyfx6kXXbOoaxW/A79wKnYb+J1j/fNbtBctxa28zyDMhP8vbRXn\nikQ/CRrai0vjH0wevp4zFW4kMkpjwg/ZieHmj4zYOxrWnyE5wKb1m13iLI5FCfWV\nLMwWSV+a1LrCd9q9HK/xITzqse5XQfrOnxSPb5lz2DqIm0ZbeauFCerzRREezCwb\nQsnv9EYb6vEvuei6k4oyt6adyIqIBp1OXRDm9ZHrAdM+fKREyFAFAennPlIoCwlv\nt361lvfU2BU1CKm8z0UUuQENBE16w8YBCADHxn/lsy89Qs/gnNg3VUK8aVE2Gqgh\nbzQ3DLPbvNrKIhQsvOyiVgRsPiF0N8SbdX5HngdjBbhdiJyQnKmqvs1mma2U3bl6\nSl+IAAnGbtgg6N+ggLd1WXfvXVZcgIJeEX8lRaJK7qe8rxv45s3f0v0XrmEZTKrm\n2TbH20/nr1prmNbCZJNKugak2lwuEtoT5ht3kFrY7FFixKfd0o/70rw6c9JfnRHT\nh6pgPkujUrW3mv1z/HtbLk0xUY/DHR43UW4+0pmGAQpz6Dw7C+OZKscU+8HwM3w1\n6R1Oj5hHbW+gkau+du4YK0pR5X0jUIMQTY/l9NuUB2niJRnNAhcjaXEbABEBAAGJ\nASUEGAECAA8FAk16w8YCGwwFCQlmAYAACgkQpScCicQ8ea2pVwf/a1IfBTd4ZRq0\nDnMWLaE4KEIqMCWXHdVe4zkSRwOwdIBEKlcGRC8H1N1cxEMgnojvY2kgsRMZzXfa\nAFo+fcw1mQpN8GjIaJrN1zdZKg5+L7uflGux4OD7RCMUNkNPNLOpgkGz/ulT/Ith\nh4UKQdW/Avo3o037hE4matiJjdttXACbUTMn8bYAAC8+ka4jiuJb74kMSxecDyl2\ntR6efiNQp5uLqXw5KVbUknFCyw2DRe0qFBlQAOxDvyDU04vJBMTOcTYXwikZ0v6I\nvvIAUBN1ReMcVhG8jav7UrDlt/yNDqYptwlRVZWgzrahO5zSYQSqmntrNoux9A9p\nwHTlkExO7w==\n=Zp4q\n-----END PGP PUBLIC KEY BLOCK-----\n"

  $key_url = 'https://rep.logentries.com/RPM-GPG-KEY-logentries'

  # you can comment this if you have a similar workaround going or no
  # facter < 1.6.1
  include logentries::helpers::oldfacter

  case $::architecture {
    'x86': {
      $yum_architecture = 'i386'
    }
    'amd64': {
      $yum_architecture = 'x86_64'
    }
    default: {
      $yum_architecture = $::architecture
    }
  }
  case $::osfamily {
    debian: {
      case $::lsbdistcodename {
        'karmic', 'lenny', 'lucid', 'maverick',
        'natty', 'oneiric', 'precise', 'quantal',
        'raring', 'saucy', 'squeeze', 'trusty',
        'utopic', 'vivid', 'wheezy', 'jessie': {
          include logentries::repo::apt
        }
        default: {
          fail "unknown compatibility for \
          ${::operatingsystem}/${::lsbdistcodename}"
          # in case you made sure, uncomment:
          # include logentries::repo::apt
        }
      }
    }
    redhat: {
      case $::lsbmajdistrelease {
        '6', '7': {
          class {'logentries::repo::yum':
            baseurl => "http://rep.logentries.com/centos6/${yum_architecture}",
          }
        }
        '5': {
          class {'logentries::repo::yum':
            baseurl => "http://rep.logentries.com/centos5/${yum_architecture}",
          }
        }
        /201./:{ # Amazon Linux
           class {'logentries::repo::yum':
               baseurl => "http://rep.logentries.com/centos6/${yum_architecture}",
           }
        }
        default: {
          fail "unknown compatibility for \
          ${::operatingsystem}/${::lsbdistcodename}"
        }
      }
    }
  }
  # FIXME: add SuSE, more redhat
}
