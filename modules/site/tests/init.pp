node default {
  include stdlib
  class { 'site': stage => 'setup' }
}
