module Publishers

  TENANTS = {
    dataone: {
      abbreviation: 'DataONE',
      short_name: 'DataONE',
      long_name: 'DataONE'
    }.freeze,
    lbnl: {
      abbreviation: 'LBNL',
      short_name: 'LBNL',
      long_name: 'Livermore National Lab'
    }.freeze,
    ucb: {
      abbreviation: 'UCB',
      short_name: 'UC Berkeley',
      long_name: 'University of California, Berkeley'
    }.freeze,
    ucd: {
      abbreviation: 'Davis',
      short_name: 'UC Davis',
      long_name: 'University of California, Davis'
    }.freeze,
    uci: {
      abbreviation: 'Irvine',
      short_name: 'UC Irvine',
      long_name: 'University of California, Irvine'
    }.freeze,
    ucla: {
      abbreviation: 'UCLA',
      short_name: 'UC Los Angeles',
      long_name: 'University of California, Los Angeles'
    }.freeze,
    ucm: {
      abbreviation: 'Merced',
      short_name: 'UC Merced',
      long_name: 'University of California, Merced'
    }.freeze,
    ucop: {
      abbreviation: 'UC',
      short_name: 'UC Office of the President',
      long_name: 'University of California, Office of the President'
    }.freeze,
    ucr: {
      abbreviation: 'Riverside',
      short_name: 'UC Riverside',
      long_name: 'University of California, Riverside'
    }.freeze,
    ucsb: {
      abbreviation: 'UCSB',
      short_name: 'UC Santa Barbara',
      long_name: 'University of California, Santa Barbara'
    }.freeze,
    ucsc: {
      abbreviation: 'UCSC',
      short_name: 'UC Santa Cruz',
      long_name: 'University of California, Santa Cruz'
    }.freeze,
    ucsf: {
      abbreviation: 'UCSF',
      short_name: 'UC San Francisco',
      long_name: 'University of California, San Francisco'
    }.freeze
  }.freeze

  TO_FIX = {
    'UCLA' => :ucla,
    'University of California-Davis' => :ucd,
    'University of California, Berkeley' => :ucb,
    'University of California, Los Angeles' => :ucla,
    'University of California, Office of the President' => :ucop,
    'University of California, San Francisco' => :ucsf,
    'University of California, Santa Cruz' => :ucsc,
    'California Digital Library' => :ucop
  }

end
