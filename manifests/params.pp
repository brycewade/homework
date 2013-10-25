# Make sure we only run on tested releases
class homework::params {
  case $::lsbdistcodename {
    'SphericalCow', 'Tikanga', 'Santiago': {}
    default: {
      fail("Module ${module_name} is not tested on ${::lsbdistcodename}")
    }
  }
}
