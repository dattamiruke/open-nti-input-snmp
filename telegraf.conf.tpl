# Telegraf configuration

# Telegraf is entirely plugin driven. All metrics are gathered from the
# declared inputs, and sent to the declared outputs.

# Plugins must be declared in here to be active.
# To deactivate a plugin, comment out the name and any variables.

# Use 'telegraf -config telegraf.conf -test' to see what metrics a config
# file would generate.

# Global tags can be specified here in key="value" format.
[tags]
  # dc = "us-east-1" # will tag all metrics with dc=us-east-1
  # rack = "1a"

# Configuration for telegraf agent
[agent]
  # Default data collection interval for all inputs
  interval = "10s"
  # Rounds collection interval to 'interval'
  # ie, if interval="10s" then always collect on :00, :10, :20, etc.
  round_interval = true

  # Telegraf will cache metric_buffer_limit metrics for each output, and will
  # flush this buffer on a successful write.
  metric_buffer_limit = 10000

  # Collection jitter is used to jitter the collection by a random amount.
  # Each plugin will sleep for a random time within jitter before collecting.
  # This can be used to avoid many plugins querying things like sysfs at the
  # same time, which can have a measurable effect on the system.
  collection_jitter = "0s"

  # Default data flushing interval for all outputs. You should not set this below
  # interval. Maximum flush_interval will be flush_interval + flush_jitter
  flush_interval = "10s"
  # Jitter the flush interval by a random amount. This is primarily to avoid
  # large write spikes for users running a large number of telegraf instances.
  # ie, a jitter of 5s and interval 10s means flushes will happen every 10-15s
  flush_jitter = "0s"

  # Run telegraf in debug mode
  debug = false
  # Run telegraf in quiet mode
  quiet = false
  # Override default hostname, if empty use os.Hostname()
  hostname = ""


###############################################################################
#                                  OUTPUTS                                    #
###############################################################################
# OUTPUTS
[outputs]

[outputs.kafka]
    # URLs of kafka brokers
    brokers = ["{{ KAFKA_ADDR }}:{{ KAFKA_PORT }}"] # EDIT THIS LINE
    # Kafka topic for producer messages
    topic = "{{ KAFKA_TOPIC }}"

# # Configuration for influxdb server to send metrics to
# [outputs.influxdb]
#   # The full HTTP or UDP endpoint URL for your InfluxDB instance.
#   # Multiple urls can be specified but it is assumed that they are part of the same
#   # cluster, this means that only ONE of the urls will be written to each interval.
#   # urls = ["udp://localhost:8089"] # UDP endpoint example
#   urls = ["http://{{ INFLUXDB_ADDR }}:{{ INFLUXDB_PORT }}"] # required
#   # The target database for metrics (telegraf will create it if not exists)
#   database = "juniper" # required
#   # Precision of writes, valid values are n, u, ms, s, m, and h
#   # note: using second precision greatly helps InfluxDB compression
#   precision = "s"
#
#   # Connection timeout (for the connection with InfluxDB), formatted as a string.
#   # If not provided, will default to 0 (no timeout)
#   # timeout = "5s"
#   # username = "telegraf"
#   # password = "metricsmetricsmetricsmetrics"
#   # Set the user agent for HTTP POSTs (can be useful for log differentiation)
#   # user_agent = "telegraf"
#   # Set UDP payload size, defaults to InfluxDB UDP Client default (512 bytes)
#   # udp_payload = 512

###############################################################################
#                                  INPUTS                                     #
###############################################################################

# Very Simple Example
[[inputs.snmp]]
  [[inputs.snmp.host]]
    address = "{{ SNMP_ADDR }}:{{ SNMP_PORT }}"
    # SNMP community
    community = "{{ SNMP_COMMUNITY }}" # default public
    # SNMP version (1, 2 or 3)
    # Version 3 not supported yet
    version = 2 # default 2
    # Simple list of OIDs to get, in addition to "collect"
    get_oids = ["{{ SNMP_OIDS }}"]

###############################################################################
#                              SERVICE INPUTS                                 #
###############################################################################
#
# # Statsd Server
# [[inputs.statsd]]
#   # Address and port to host UDP listener on
#   service_address = ":8125"
#   # Delete gauges every interval (default=false)
#   delete_gauges = true
#   # Delete counters every interval (default=false)
#   delete_counters = false
#   # Delete sets every interval (default=false)
#   delete_sets = false
#   # Delete timings & histograms every interval (default=true)
#   delete_timings = true
#   # Percentiles to calculate for timing & histogram stats
#   percentiles = [90]
#
#   # convert measurement names, "." to "_" and "-" to "__"
#   convert_names = true
#
#   # templates = [
#   #     "cpu.* measurement*"
#   # ]
#
#   # Number of UDP messages allowed to queue up, once filled,
#   # the statsd server will start dropping packets
#   allowed_pending_messages = 10000
#
#   # Number of timing/histogram values to track per-measurement in the
#   # calculation of percentiles. Raising this limit increases the accuracy
#   # of percentiles but also increases the memory usage and cpu time.
#   percentile_limit = 1000
#
#   # UDP packet size for the server to listen for. This will depend on the size
#   # of the packets that the client is sending, which is usually 1500 bytes.
#   udp_packet_size = 1500
