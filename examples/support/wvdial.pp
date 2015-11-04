include debnet

debnet::support::wvdial { 'myconf':
  device   => '/dev/ttyACM1',
  baud     => '460800',
  username => 'blank',
  password => 'blank',
  init     => [
    'ATZ',
    'ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0',
    'AT+CFUN=1',
    'AT+CGDCONT=1,"IP","INTERNETSTATIC", "192.168.1.24"'
  ]
}