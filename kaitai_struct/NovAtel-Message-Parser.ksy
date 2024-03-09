meta:
  id: novatel
  license: MIT
  file-extension: dat
  endian: le
seq:
  - id: all_novatel_messages
    type: novatel_message
#    repeat: eos
    repeat: expr 
#    repeat-expr: 63
    repeat-expr: 9714



# G3: 0xAACC4756
# Header Length: 28
# + 4 + 64*142 + 4

# Legacy: 0xAA4412


types:
  novatel_message:
    seq:
    - id: sync_bytes
      type: u4
      enum: novatel_header_types
      doc: Using 4 Bytes
      doc-ref: https://novatel.com/support/high-precision-gnss-gps-receivers/specialty-ground-reference-receivers/waas-g-iii-receiver "NovAtel G3"
    - id: novatel_header_type
      type:
        switch-on: sync_bytes
        cases:
          'novatel_header_types::bbb_junk': bbb_junk
          'novatel_header_types::novatel_ascii_rxcommands': novatel_ascii_rxcommands
          'novatel_header_types::novatel_binary_legacy_header': novatel_binary_legacy_message
          'novatel_header_types::novatel_binary_g3_header': novatel_binary_g3_message
#         _: rec_type_unknown

  bbb_junk:
    seq:
      - id: more_junk
        type: u4

  novatel_ascii_rxcommands:
    seq:
      - id: message_name
        type: str
        terminator: 0x2c
        encoding: UTF-8
      - id: port
        type: str
        terminator: 0x2c
        encoding: UTF-8
      - id: reserved1
        type: str
        terminator: 0x2c
        encoding: UTF-8
      - id: idle_time
        type: str
        terminator: 0x2c
        encoding: UTF-8
      - id: time_status
        type: str
        terminator: 0x2c
        encoding: UTF-8
      - id: week
        type: str
        terminator: 0x2c
        encoding: UTF-8
      - id: seconds
        type: str
        terminator: 0x2c
        encoding: UTF-8
      - id: receiver_status
        type: str
        terminator: 0x2c
        encoding: UTF-8
      - id: reserved2
        type: str
        terminator: 0x2c
        encoding: UTF-8
      - id: reserved3
        type: str
        terminator: 0x3b
        encoding: UTF-8
      - id: command_type
        type: str
        terminator: 0x2c
        encoding: UTF-8
      - id: embedded_message
        type: str
        terminator: 0x2a
        encoding: UTF-8
      - id: checksum
        type: str
        terminator: 0x0d
        encoding: UTF-8
      - id: message_terminator
        type: str
        terminator: 0x0a
        encoding: UTF-8

  novatel_binary_g3_message:
    seq:
      - id: message_length
        type: u2
      - id: g3_message_id
        type: u2
        enum: novatel_g3_message_types
      - id: log_count
        type: u4
      - id: time_status
        type: u2
      - id: gps_week
        type: u2
      - id: gps_milliseconds
        type: u4
      - id: reserved_1
        size: 4
      - id: reserved_2
        size: 2
      - id: reserved_3
        size: 2
      - id: novatel_binary_g3_message_body
        type:
          switch-on: g3_message_id
          cases:
            'novatel_g3_message_types::measurementdata': measurementdata
            'novatel_g3_message_types::test': test
#            _: rec_type_unknown
      - id: crc
        size: 4

  test:
    seq:
      - id: test
        type: u1
        
  novatel_binary_legacy_message:
    seq:
#      - id: third_sync_byte
#        contents: [0x12]
#      - id: header_length
#        type: u1
      - id: message_id
        type: u2
        enum: novatel_legacy_message_types
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
      - id: novatel_binary_legacy_message_body
        type:
          switch-on: message_id
          cases:
            'novatel_legacy_message_types::range': range
            'novatel_legacy_message_types::time': time
            'novatel_legacy_message_types::rawwaasframewp': rawwaasframewp
            'novatel_legacy_message_types::agcstats': agcstats
            'novatel_legacy_message_types::allsqmi': allsqmi
            'novatel_legacy_message_types::allsqmq': allsqmq
            'novatel_legacy_message_types::rxsecstatus': rxsecstatus
            'novatel_legacy_message_types::systemlevels': systemlevels
  #          _: rec_type_unknown
      - id: crc
        size: 4

  measurementdata:
    seq:
      - id: measurementdata_num_of_observations
        type: u4
      - id: measurementdata_observations
        type: measurementdata_observation
        repeat: expr
        repeat-expr: measurementdata_num_of_observations
    types:
      measurementdata_observation:
        seq:
          - id: measurementdata_observation_stub
            size: 64
        

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

## agcstats ##a

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
        type: allsqmi_satellite
        repeat: expr
        repeat-expr: num_of_tracked_satellites
  allsqmi_satellite:
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
        type: allsqmq_satellite
        repeat: expr
        repeat-expr: num_of_tracked_satellites
  allsqmq_satellite:
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
      - id: systemlevels_num_of_components
        type: u4
      - id: systemlevels_components
        type: systemlevels_components
        repeat: expr
        repeat-expr: systemlevels_num_of_components
  systemlevels_components:
    seq:
      - id: systemlevels_components_stub
        size: 48
        
## NovAtel Message IDs ##
#    0x0bbb0bbb: bbb_junk
#    0xaa4412c1: novatel_binary_legacy_header
#    0xaacc4756: novatel_binary_g3_header
#    0x21528867: novatel_ascii_rxcommands

enums:
  novatel_header_types:
    0xBB0BBB0B: bbb_junk
    0x1c1244aa: novatel_binary_legacy_header
    0x5647ccaa: novatel_binary_g3_header
    0x67885221: novatel_ascii_rxcommands
  
  
  novatel_binary_header_types:
    0x44: novatel_binary_legacy_header
    0xcc: novatel_binary_g3_header

  novatel_g3_message_types:
    1: test
    4103: measurementdata


  novatel_legacy_message_types:
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
