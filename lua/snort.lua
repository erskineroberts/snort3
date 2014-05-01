---------------------------------------------------------------------------
-- This file contains a sample snort configuration.  You should follow
-- the steps to create your own custom configuration.
--
-- let install_dir be a variable indicating where you installed Snort++.
-- then do:
--
-- export LUA_PATH=$install_dir/include/snort/lua/?.lua\;\;
-- export SNORT_LUA_PATH=$install_dir/conf/
---------------------------------------------------------------------------

require('snort_config')

-- useful constants
K = 1024
M = K * K
G = M * K

---------------------------------------------------------------------------
-- Step #1: Set paths, ports, and nets:
--
-- variables with 'PATH' in the name are vars
-- variables with 'PORT' in the name are portvars
-- variables with 'NET' in the name are ipvars
-- variables with 'SERVER' in the name are ipvars
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- paths
---------------------------------------------------------------------------
-- Path to your rules files (this can be a relative path)
-- Note for Windows users:  You are advised to make this an absolute path,
-- such as:  c:\snort\rules

RULE_PATH = '../rules'
BUILTIN_RULE_PATH = '../preproc_rules'
PLUGIN_RULE_PATH = '../so_rules'

-- If you are using reputation preprocessor set these
WHITE_LIST_PATH = '../lists'
BLACK_LIST_PATH = '../lists'

---------------------------------------------------------------------------
-- networks
---------------------------------------------------------------------------
-- Setup the network addresses you are protecting
HOME_NET = 'any'

-- Set up the external network addresses. Leave as "any" in most situations
EXTERNAL_NET = 'any'

-- List of DNS servers on your network 
DNS_SERVERS = HOME_NET

-- List of SMTP servers on your network
SMTP_SERVERS = HOME_NET

-- List of web servers on your network
HTTP_SERVERS = HOME_NET

-- List of sql servers on your network 
SQL_SERVERS = HOME_NET

-- List of telnet servers on your network
TELNET_SERVERS = HOME_NET

-- List of ssh servers on your network
SSH_SERVERS = HOME_NET

-- List of ftp servers on your network
FTP_SERVERS = HOME_NET

-- List of sip servers on your network
SIP_SERVERS = HOME_NET

-- other variables, these should not be modified
AIM_SERVERS =
[[
64.12.24.0/23
64.12.28.0/23
64.12.161.0/24
64.12.163.0/24
64.12.200.0/24
205.188.3.0/24
205.188.5.0/24
205.188.7.0/24
205.188.9.0/24
205.188.153.0/24
205.188.179.0/24
205.188.248.0/24
]]

---------------------------------------------------------------------------
-- ports
---------------------------------------------------------------------------
-- List of ports you run web servers on
HTTP_PORTS =
[[
    80 81 311 383 591 593 901 1220 1414 1741 1830 2301 2381 2809 3037 3128
    3702 4343 4848 5250 6988 7000 7001 7144 7145 7510 7777 7779 8000 8008
    8014 8028 8080 8085 8088 8090 8118 8123 8180 8181 8243 8280 8300 8800
    8888 8899 9000 9060 9080 9090 9091 9443 9999 11371 34443 34444 41080
    50002 55555 
]]

-- List of ports you want to look for SHELLCODE on.
SHELLCODE_PORTS = ' !80'

-- List of ports you might see oracle attacks on
ORACLE_PORTS = ' 1024:'

-- List of ports you want to look for SSH connections on:
SSH_PORTS = ' 22'

-- List of ports you run ftp servers on
FTP_PORTS = ' 21 2100 3535'

-- List of ports you run SIP servers on
SIP_PORTS = ' 5060 5061 5600'

MAIL_PORTS = ' 110 143'

-- List of file data ports for file inspection
FILE_DATA_PORTS = HTTP_PORTS .. MAIL_PORTS

-- List of GTP ports for GTP preprocessor
GTP_PORTS = ' 2123 2152 3386'

RPC_PORTS = 
    ' 111 32770 32771 32772 32773 32774 32775 32776 32777 32778 32779'

-- Configure ports to ignore 
--[[
ignore_ports =
{
    tcp = ' 21 6667:6671 1356'
    udp = ' 1:17 53'
}
--]]

tcp_client_ports = SSH_PORTS .. FTP_PORTS .. MAIL_PORTS .. RPC_PORTS ..
[[
    23 25 42 53 79 109 113 119 135 136 137 139 161 445 513 514 587 593 691
    1433 1521 1741 3306 6070 6665 6666 6667 6668 6669 7000 8181 
]]
tcp_server_ports = ''
tcp_both_ports = HTTP_PORTS ..
[[
    443 465 563 636 989 992 993 994 995 7907 7802 7801 7900 7901 7902 7903
    7904 7905 7906 7908 7909 7910 7911 7912 7913 7914 7915 7916 7917 7918
    7919 7920
]]

---------------------------------------------------------------------------
-- Step #2: configure builtin features
---------------------------------------------------------------------------

-- Configure active response for non inline operation.
active =
{
    device = 'eth0',
    attempts = 2,
    --max_active_responses = 2,
    --min_response_seconds = 5
}

-- Configure DAQ related options for inline operation.
-- <name> ::= pcap | afpacket | dump | nfq | ipq | ipfw
-- <mode> ::= read_file | passive | inline
-- <var> ::= arbitrary <name>=<value passed to DAQ
-- <dir> ::= path to DAQ module so's
daq =
{
    --name = 'dump',
    --var = { <var> }
}

-- Configure PCRE match limits
limit = 750

detection = 
{
    pcre_match_limit = 3 * limit,
    pcre_match_limit_recursion = limit
}

-- Configure the detection engine
search_engine =
{
    search_method = 'ac_full_q',
    --search_method = 'lowmem_q',
    split_any_any = true,
    search_optimize = true,
    max_pattern_len = 20
}

-- Configure the event queue.
event_queue =
{
    max_queue = 8,
    log = 5,
    order_events = 'content_length'
}

-- Per packet and rule latency enforcement
ppm =
{
-- Per Packet latency configuration
    max_pkt_time = 250,
    fastpath_expensive_packets = true,
    pkt_log = 'log',

-- Per Rule latency configuration
    max_rule_time = 200,
    threshold = 3,
    suspend_expensive_rules = true,
    suspend_timeout = 20,
    rule_log = 'alert'
}

-- Configure Perf Profiling for debugging
profile =
{
    rules =
    {
        count = 10,
        sort = 'avg_ticks',
        file = { append = true }
    },
    preprocs =
    {
        count = 10,
        sort = 'avg_ticks',
        file = { append = true }
    }
}

---------------------------------------------------------------------------
-- Step #3: Configure inspectors
---------------------------------------------------------------------------
normalize =
{ 
    ip4 = 
    {
        base = true, df = true, rf = true, tos = true, trim = false
    },
    tcp =
    {
        base = true, ips = true, urp = true, trim = false, 
        ecn = 'stream', opts = true, 
        allow_codes = '123 224',
        allow_names = 'sack echo partial_order conn_count alt_checksum md5'
    },
    ip6 = true,
    icmp4 = true,
    icmp6 = true
}

--defrag_global = { max_frags = 65536 }

defrag_engine =
{
    policy = 'windows', 
    detect_anomalies = true,
    overlap_limit = 10,
    min_frag_length = 100,
    timeout = 180
}

arp_spoof =
{
    unicast = true,
    hosts =
    {
        { ip = '192.168.40.1', mac = 'f0:0f:00:f0:0f:00' },
        { ip = '192.168.40.2', mac = '0f:f0:00:0f:f0:00' }
    }
}

back_orifice = { }

rpc_decode =
{
    ports = RPC_PORTS
}

port_scan_global = { memcap = 10000000 }

port_scan =
{
    protos = 'all',
    scan_types = 'all',
    sense_level = 'low',
    watch_ip = '![1.2.3.4]',
    ignore_scanners = '2.3.4.5/24',
    ignore_scanned = '4.5.6.7/8 9-10',
    include_midstream = true,
}

perf_monitor =
{
    packets = 10101,
    seconds = 60,
    reset = true,

    max_file_size = 2147483648,

    --max = true, -- max data output only to console?
    --console = true,

    -- everything should go to fixed name file in instance dir
    -- remove _file options and keep prefix to enable file or not
    --file = true,
    --events = true,
    flow = true,
    flow_file = true,
    --flow_ip = true,
    --flow_ip_file = true,
    --flow_ip_memcap = 52428800
}

---------------------------------------------------------------------------
-- HTTP normalization and anomaly detection.
---------------------------------------------------------------------------

http_global =
{
    unicode_map =
    {
        map_file = '/etc/unicode.map',
        code_page = 1252
    },
    compress_depth = 65535,
    decompress_depth = 65535
}

default_http_methods =
[[
    GET POST PUT SEARCH MKCOL COPY MOVE LOCK UNLOCK NOTIFY POLL BCOPY
    BDELETE BMOVE LINK UNLINK OPTIONS HEAD DELETE TRACE TRACK CONNECT
    SOURCE SUBSCRIBE UNSUBSCRIBE PROPFIND PROPPATCH BPROPFIND BPROPPATCH
    RPC_CONNECT PROXY_SUCCESS BITS_POST CCM_POST SMS_POST RPC_IN_DATA
    RPC_OUT_DATA RPC_ECHO_DATA
]]

http_server =
{
    unicode_map =
    {
        map_file = '/etc/unicode.map',
        code_page = 1252
    },
    http_methods = default_http_methods,
    chunk_length = 500000,
    server_flow_depth = 0,
    client_flow_depth = 0,
    post_depth = 65495,
    oversize_dir_length = 500,
    max_header_length = 750,
    max_headers = 100,
    max_spaces = 200,
    small_chunk_length = { size = 10, count = 5 },
    ports = HTTP_PORTS,
    non_rfc_chars = '0x00 0x01 0x02 0x03 0x04 0x05 0x06 0x07',
    enable_cookies = true,
    extended_response_inspection = true,
    inspect_gzip = true,
    normalize_utf = true,
    unlimited_decompress = true,
    normalize_javascript = true,
    apache_whitespace = false,
    ascii = false,
    bare_byte = false,
    directory = false,
    double_decode = false,
    iis_backslash = false,
    iis_delimiter = false,
    iis_unicode = false,
    multi_slash = false,
    utf_8 = false,
    u_encode = true,
    webroot = false
}

---------------------------------------------------------------------------
-- FTP / Telnet normalization and anomaly detection.
---------------------------------------------------------------------------

telnet =
{
    encrypted_traffic = false,
    check_encrypted = true,
    ayt_attack_thresh = 20,
    normalize = true,
    ports = '23',
    detect_anomalies = true
}

ftp_global =
{
    encrypted_traffic = false,
    check_encrypted = true,
}

ftp_default_commands =
[[
    ABOR ACCT ADAT ALLO APPE AUTH CCC CDUP CEL CLNT CMD CONF CWD DELE ENC
    EPRT EPSV ESTA ESTP FEAT HELP LANG LIST LPRT LPSV MACB MAIL MDTM MIC
    MKD MLSD MLST MODE NLST NOOP OPTS PASS PASV PBSZ PORT PROT PWD QUIT
    REIN REST RETR RMD RNFR RNTO SDUP SITE SIZE SMNT STAT STOR STOU STRU
    SYST TEST TYPE USER XCUP XCRC XCWD XMAS XMD5 XMKD XPWD XRCP XRMD XRSQ
    XSEM XSEN XSHA1 XSHA256
]]

ftp_format_commands = 
[[ 
    ACCT ADAT ALLO APPE AUTH CEL CLNT CMD CONF CWD DELE ENC EPRT EPSV ESTP
    HELP LANG LIST LPRT MACB MAIL MDTM MIC MKD MLSD MLST MODE NLST OPTS
    PASS PBSZ PORT PROT REST RETR RMD RNFR RNTO SDUP SITE SIZE SMNT STAT
    STOR STRU TEST TYPE USER XCRC XCWD XMAS XMD5 XMKD XRCP XRMD XRSQ XSEM
    XSEN XSHA1 XSHA256
]]

ftp_server =
{
    ports = FTP_PORTS,
    def_max_param_len = 100,

    encrypted_traffic = false,
    check_encrypted = true,
    print_cmds = false,
    telnet_cmds = true,
    ignore_telnet_erase_cmds = true,
    ignore_data_chan = true,

    ftp_cmds = ftp_default_commands,
    chk_str_fmt = ftp_format_commands,

    alt_max_param =
    {
        { length = 0, 
          commands = [[ ABOR CCC CDUP ESTA FEAT LPSV
                    NOOP PASV PWD QUIT REIN STOU SYST XCUP XPWD ]] },

        { length = 200, 
          commands = 'ALLO APPE CMD HELP NLST RETR RNFR STOR STOU XMKD' },

        { length = 256, commands = 'CWD RNTO' },
        { length = 400, commands = 'PORT' },
        { length = 512, commands = 'SIZE' },
    },

    cmd_validity =
    {
        { command = 'ALLO', format = '< int [ char R int ] >' },
        { command = 'EPSV', format = '< [ { char 12 | char A char L char L } ] >' },
        { command = 'MACB', format = '< string >' },
        { command = 'MDTM', format = '< [ date nnnnnnnnnnnnnn[.n[n[n]]] ] string >' },
        { command = 'MODE', format = '< char ASBCZ >' },
        { command = 'PORT', format = '< host_port >' },
        { command = 'PROT', format = '< char CSEP >' },
        { command = 'STRU', format = '< char FRPO [ string ] >' },
        { command = 'TYPE', format = '< { char AE [ char NTC ] | char I | char L [ number ] } >' }
    },
}

ftp_client =
{
    max_resp_len = 256,
    bounce = true,
    ignore_telnet_erase_cmds = true,
    telnet_cmds = true,

--[[
    bounce_to =
    {
        { address = '192.168.1.1', port = 12345 },
        { address = '192.168.144.120', port = 50010, last_port = 50020 }
    }
--]]
}

---------------------------------------------------------------------------
-- the following inspector configs are just prototypes
-- they are nominally validated but they are not actually loaded
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Target-Based stateful inspection/stream reassembly.
---------------------------------------------------------------------------

stream_global =
{
    tcp_memcap = 123456789,
    show_rebuilt_packets = false,
    prune_log_max = 0,
    paf_max = 16384,
    
    tcp_cache = { max_sessions = 256 * K, idle_timeout = 60 },
    udp_cache = { max_sessions = 128 * K, pruning_timeout = 30 },
    ip_cache = { max_sessions = 64 * K },
    icmp_cache = { max_sessions = 32 * K },

    active_response = 
    {
        max_responses = 0,
        min_interval = 1
    }
}

stream_tcp =
{
    policy = 'windows',

    session_timeout = 180,
    require_3whs = 180,
    flush_factor = 0,

    overlap_limit = 10,

    queue_limit =
    {
        max_bytes = 3,
        max_segments = 1300,
    },
    small_segments = 
    {
        count = 10,
        maximum_size = 128,
        ignore_ports = '1 2 3'
    },

    footprint = 0,
    reassemble_async = false,
    ignore_any_rules = false,

    client_ports = tcp_client_ports,
    server_ports = tcp_server_ports,
    both_ports = tcp_both_ports,
}

stream_udp =
{
    session_timeout = 180,
    ignore_any_rules = false,
}

stream_icmp =
{
    session_timeout = 180,
}

stream_ip =
{
    session_timeout = 180,
}

---------------------------------------------------------------------------
-- Step #4: Configure loggers
---------------------------------------------------------------------------

-- alerts + packets
unified2 =
{
    file = 'u2.log',
    limit = 128,
    units = 'M',
    nostamp = true,
    mpls_event_types = true,
    vlan_event_types = true
}

-- text
--alert_syslog = { mode = 'LOG_AUTH LOG_ALERT' }
alert_fast = { }
alert_full = { }
--alert_test = { file = 'alert.tsv', session = false, msg = true }
--alert_csv = { file = 'alert.csv' }

-- pcap
log_tcpdump = { file = 'snort++.pcap' }

---------------------------------------------------------------------------
-- Step #6: Customize your rule set
--
-- NOTE: All categories are enabled in this conf file
---------------------------------------------------------------------------

dir = os.getenv('SNORT_LUA_PATH')

if ( not dir ) then
    dir = ''
end

dofile(dir .. 'classification.lua')
dofile(dir .. 'reference.lua')

--[[
event_filter =
{
    { gid = 1, sid = 2, type = 'both', count = 1, seconds = 5 },
    { gid = 1, sid = 1, type = 'both', count = 1, seconds = 5 }
}
--]]
--
suppress =
{
    { gid = 116, sid = 408 },
    { gid = 116, sid = 412 },
    { gid = 116, sid = 414 },
}

default_rules =
[[
#output unified2: filename snort.alert, limit 128, nostamp
# snort-classic comments, includes, and rules with $VARIABLES
# (rules files support the same syntax)

# builtin rules
#include $BUILTIN_RULE_PATH/preprocessor.rules
#include $BUILTIN_RULE_PATH/decoder.rules
#include $BUILTIN_RULE_PATH/sensitive-data.rules

# text rules
#include $RULE_PATH/local.rules
#include $RULE_PATH/app-detect.rules
#include $RULE_PATH/attack-responses.rules
#include $RULE_PATH/backdoor.rules

# so rules
#include $PLUGIN_RULE_PATH/bad-traffic.rules
#include $PLUGIN_RULE_PATH/chat.rules
#include $PLUGIN_RULE_PATH/dos.rules

alert tcp any any -> any 80 ( sid:1; msg:"1"; content:"HTTP"; )
alert tcp any 80 -> any any ( sid:2; msg:"2"; content:"HTTP"; )
]]

network =
{
    checksum_eval = 'all'
}

-- put classic rules and includes in the include file and/or rules string
ips =
{
    --include = '../active.rules',
    --rules = default_rules,
    enable_builtin_rules = true
}

-- prototype bindings:
-- nets and ports move out of inspector configurations
-- only need to specify non-default bindings

bindings =
{
    {
        when =
        {
            id = 'uuid', vlans = '123', nets = '1.2.3.0/24',
            protos = 'tcp', ports = '80', role = 'any'
        },
        use = { type = 'http_inspect', name = 'hi2' }
    },
    {
        when = { nets = '1.2.3.4', protos = 'tcp', ports = '80 8080' },
        action = 'block'
    },
}
 
