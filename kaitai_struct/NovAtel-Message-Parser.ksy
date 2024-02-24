meta:
  id: novatel
  file-extension: dat
  endian: le
seq:
  - id: all_novatel_messages
    type: novatel_message
#    repeat: eos
    repeat: expr
    repeat-expr: 9713

types:
  novatel_message:
    seq:
    - id: novatel_header
      type: novatel_header
    - id: novatel_message_body
      type:
        switch-on: novatel_header.message_id
        cases:
          'novatel_message_types::range': range
          'novatel_message_types::time': time
          'novatel_message_types::rawwaasframewp': rawwaasframewp
          'novatel_message_types::agcstats': agcstats
          'novatel_message_types::allsqmi': allsqmi
          'novatel_message_types::allsqmq': allsqmq
          'novatel_message_types::rxsecstatus': rxsecstatus
          'novatel_message_types::systemlevels': systemlevels
#          _: rec_type_unknown
    - id: crc
      size: 4
      
## NoVatel Header ##

  novatel_header:
    seq:
      - id: sync
        contents: [0xaa, 0x44, 0x12]
      - id: header_length
        type: u1
      - id: message_id
        type: u2
        enum: novatel_message_types
      - id: message_type
        type: u1
      - id: port_address
        type: u1
      - id: message_length
        type: u2
      - id: sequence
        type: u2
      - id: idle_time
        type: u1
      - id: time_status
        type: u1
      - id: gps_week
        type: u2
      - id: gps_milliseconds
        type: u4
      - id: receiver_status
        type: u4
      - id: reserved_1
        size: 4

## range ##

  range:
    seq:
      - id: num_of_data_sets
        type: u4
      - id: range_data_sets
        type: range_data_set
        repeat: expr
        repeat-expr: num_of_data_sets
  range_data_set:
    seq:
      - id: range_data_set_stub
        size: 44

## time ##

  time:
    seq:
      - id: num_of_components
        type: u4
      - id: clock_status
        type: u4
      - id: offset
        type: f8
      - id: offset_std
        type: f8
      - id: reserved
        size: 20


## rawwaasframewp ##

  rawwaasframewp:
    seq:
      - id: channel_number
        type: u4
      - id: geo_prn
        type: u4
      - id: parity_flag
        type: u4
      - id: sbas_frame
        size: 32

## agcstats ##

  agcstats:
    seq:
      - id: num_of_rf_decks
        type: u4
      - id: agcstats_rf_decks
        type: agcstats_rf_deck
        repeat: expr
        repeat-expr: num_of_rf_decks
  agcstats_rf_deck:
    seq:
      - id: agc_word
        type: u4
      - id: gain
        type: u4
      - id: pulse_width
        type: u4
      - id: modulus
        type: u4
      - id: bin1
        type: f8
      - id: bin2
        type: f8
      - id: bin3
        type: f8
      - id: bin4
        type: f8
      - id: bin5
        type: f8
      - id: bin6
        type: f8
      - id: noise_floor
        type: f8
      - id: reserved_1
        type: f8
      - id: reserved_2
        type: f8

## allsqmi ##
  allsqmi:
    seq:
      - id: num_of_tracked_satellites
        type: u4
      - id: satellite_data
        type: satellite
        repeat: expr
        repeat-expr: num_of_tracked_satellites
  satellite:
    seq:
      - id: prn_number
        type: u4
      - id: signal_channel
        type: u4
      - id: number_of_accumulations
        type: u4
      - id: accumulation
        type: s4
        repeat: expr
        repeat-expr: number_of_accumulations

## allsqmq ##

  allsqmq:
    seq:
      - id: num_of_tracked_satellites
        type: u4
      - id: satellite_data
        type: satellite
        repeat: expr
        repeat-expr: num_of_tracked_satellites
  satellite:
    seq:
      - id: prn_number
        type: u4
      - id: signal_channel
        type: u4
      - id: number_of_accumulations
        type: u4
      - id: accumulation
        type: s4
        repeat: expr
        repeat-expr: number_of_accumulations

## rxsecstatus ##

  rxsecstatus:
    seq:
      - id: num_of_components
        type: u4
      - id: rxsecstatus_components
        type: rxsecstatus_components
        repeat: expr
        repeat-expr: num_of_components
  rxsecstatus_components:
    seq:
      - id: rxsecstatus_components_stub
        size: 68

## agcstats ##

  systemlevels:
    seq:
      - id: num_of_components
        type: u4
      - id: systemlevels_components
        type: systemlevels_components
        repeat: expr
        repeat-expr: num_of_components
  systemlevels_components:
    seq:
      - id: systemlevels_components_stub
        size: 48
        
## NovAtel Message IDs ##

enums:
  novatel_message_types:
  # Partial
    43: range
  # Full
    101: time
  # Full
    571: rawwaasframewp
  # Full
    630: agcstats
  # Partial
    632: allsqmi
  # Partial
    633: allsqmq
  # Partial
    638: rxsecstatus
  # Partial
    653: systemlevels