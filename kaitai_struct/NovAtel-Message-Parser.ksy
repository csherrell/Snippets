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
    #    repeat-expr: 15124
    repeat-expr: 100
#    repeat-expr: 9714
#   repeat-expr: 17000

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
        #      eos-error: false
        doc-ref: https://novatel.com/support/high-precision-gnss-gps-receivers/specialty-ground-reference-receivers/waas-g-iii-receiver "NovAtel G3"
      - id: novatel_header_type
        type:
          switch-on: sync_bytes
          cases:
            'novatel_header_types::fragmented_udp': fragmented_udp
            'novatel_header_types::novatel_ascii_rxcommands': novatel_ascii_rxcommands
            'novatel_header_types::novatel_binary_legacy_header': novatel_binary_legacy_message
            'novatel_header_types::novatel_binary_g3_header': novatel_binary_g3_message
            _: record_type_unknown
            # Reassembled UDP Packet
  fragmented_udp:
    seq:
      - id: fragmented_udp_data
        type: u4
        # Catch all for unknonwn message types
  record_type_unknown:
    seq:
      - id: rec_type_unknown_data
        type: u4
        # NovAtel ASCII RXCOMMANDS Log
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
        # NovAtel Legacy Header
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
            'novatel_legacy_message_types::rawephem': rawephem
            'novatel_legacy_message_types::range': range
            'novatel_legacy_message_types::time': time
            'novatel_legacy_message_types::rawgpsframewp': rawgpsframewp
            'novatel_legacy_message_types::rawwaasframewp': rawwaasframewp
            'novatel_legacy_message_types::agcstats': agcstats
            'novatel_legacy_message_types::allsqmi': allsqmi
            'novatel_legacy_message_types::allsqmq': allsqmq
            'novatel_legacy_message_types::rxsecstatus': rxsecstatus
            'novatel_legacy_message_types::systemlevels': systemlevels
      - id: crc
        size: 4
        # NovAtel G-III Header
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
            'novatel_g3_message_types::agcinfo': agcinfo
            'novatel_g3_message_types::cardstatus': cardstatus
            'novatel_g3_message_types::corrdata': corrdata
            'novatel_g3_message_types::ethstatus': ethstatus
            'novatel_g3_message_types::factorydata': factorydata
            'novatel_g3_message_types::measurementdata': measurementdata
            'novatel_g3_message_types::satpos': satpos
            'novatel_g3_message_types::rawframedata': rawframedata
            'novatel_g3_message_types::rxcommands': rxcommands
            'novatel_g3_message_types::timesolution': timesolution
            'novatel_g3_message_types::version': version
      - id: crc
        size: 4
        # NovAtel Legacy Log Messages
  rawephem:
    seq:
      - id: prn
        type: u4
      - id: ref_week
        type: u4
      - id: ref_secs
        type: u4
      - id: subframe_1
        size: 30
      - id: subframe_2
        size: 30
      - id: subframe_3
        size: 30
      - id: padding_8_byte_alignment
        size: 2
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
  rawgpsframewp:
    seq:
      - id: channel_number
        type: u4
      - id: prn
        type: u4
      - id: parity_failuers
        type: u4
      - id: raw_subframe_data
        size: 40
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
        # NovAtel Legacy Log Messages
  agcinfo:
    seq:
      - id: num_of_entries
        type: u4
      - id: agcinfo_data
        type: agcinfo_measurement
        repeat: expr
        repeat-expr: num_of_entries
    types:
      agcinfo_measurement:
        seq:
          - id: agcinfo_stub
            size: 88
  cardstatus:
    seq:
      - id: cardstatus_stub
        size: 16
      - id: number_of_cards
        type: u4
      - id: cardstatus_data
        type: card_status
        repeat: expr
        repeat-expr: number_of_cards
      - id: number_of_fans
        type: u4
      - id: fan_data
        type: fan_status
        repeat: expr
        repeat-expr: number_of_fans
    types:
      card_status:
        seq:
          - id: card_status_stub
            size: 60
      fan_status:
        seq:
          - id: fan_speed
            type: u2
          - id: fan_failed
            type: u2
  corrdata:
    seq:
      - id: num_of_entries
        type: u4
      - id: correlator_data
        type: correlator_measurement
        repeat: expr
        repeat-expr: num_of_entries
    types:
      correlator_measurement:
        seq:
          - id: correlator_measurement_stub
            size: 12
          - id: number_of_bins
            type: u4
          - id: correlation_bins
            type: correlation_bin
            repeat: expr
            repeat-expr: number_of_bins
      correlation_bin:
        seq:
          - id: bin_value_i
            type: u4
          - id: bin_value_q
            type: u4
  ethstatus:
    seq:
      - id: num_of_records
        type: u4
      - id: ethstatus_records
        type: ethstatus_record
        repeat: expr
        repeat-expr: num_of_records
    types:
      ethstatus_record:
        seq:
          - id: ethstatus_record_stub
            size: 28
  factorydata:
    seq:
      - id: number_of_entries
        type: u4
      - id: manufacturer_data
        type: data_string
        repeat: expr
        repeat-expr: number_of_entries
    types:
      data_string:
        seq:
          - id: manufacturer_data_sting
            type: str
            encoding: ASCII
            size: 512
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
  satpos:
    seq:
      - id: satpos_stub
        size: 12
      - id: num_of_entries
        type: u4
      - id: satpos_data
        type: satpos_entry
        repeat: expr
        repeat-expr: num_of_entries
    types:
      satpos_entry:
        seq:
          - id: satpos_entry_stub
            size: 40
  rawframedata:
    seq:
      - id: rawframedata_stub
        size: 16
      - id: rawframedata_bits_in_frame
        type: u4
      - id: rawframedata_number_of_bytes
        type: u4
      - id: rawframedata_data
        size: rawframedata_number_of_bytes
  rxcommands:
    seq:
      - id: number_of_entries
        type: u4
      - id: total_length
        size: _parent.message_length - 32
  timesolution:
    seq:
      - id: timesolution_stub
        size: 32
      - id: number_of_channels
        type: u4
      - id: channel_data
        type: channel_info
        repeat: expr
        repeat-expr: number_of_channels
    types:
      channel_info:
        seq:
          - id: channel_info_stub
            size: 52
  version:
    seq:
      - id: num_of_components
        type: u4
      - id: components
        type: component
        repeat: expr
        repeat-expr: num_of_components
    types:
      component:
        seq:
          - id: component_stub
            size: 232
enums:
  novatel_header_types:
    0xBB0BBB0B: fragmented_udp
    0x1c1244aa: novatel_binary_legacy_header
    0x5647ccaa: novatel_binary_g3_header
    0x43585223: novatel_ascii_rxcommands
  novatel_binary_header_types:
    0x44: novatel_binary_legacy_header
    0xcc: novatel_binary_g3_header
  novatel_legacy_message_types:
    # Partial
    41: rawephem
    43: range
    # Full
    101: time
    # Full
    570: rawgpsframewp
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
  novatel_g3_message_types:
    4096: agcinfo
    4098: cardstatus
    4099: corrdata
    4101: ethstatus
    4102: factorydata
    4103: measurementdata
    4104: rawframedata
    4105: rxcommands
    4106: satpos
    4107: timesolution
    4108: version
