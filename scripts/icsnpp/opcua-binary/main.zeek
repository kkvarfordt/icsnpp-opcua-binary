## main.zeek
##
## OPCUA Binary Protocol Analyzer
##
## Base script layer functionality for processing events emitted from
## the analyzer.
##
## Author:   Kent Kvarfordt
## Contact:  kent.kvarfordt@inl.gov
##
## Copyright (c) 2022 Battelle Energy Alliance, LLC.  All rights reserved.

module ICSNPP_OPCUA_Binary;

export {
	redef enum Log::ID += { LOG, LOG_STATUS_CODE, LOG_DIAG_INFO, LOG_OPENSECURE_CHANNEL, 
                           LOG_GET_ENDPOINTS, LOG_GET_ENDPOINTS_DISCOVERY,  LOG_GET_ENDPOINTS_USER_TOKEN,
                           LOG_CREATE_SESSION, LOG_CREATE_SESSION_DISCOVERY, LOG_CREATE_SESSION_ENDPOINTS, LOG_CREATE_SESSION_USER_TOKEN, 
                           LOG_BROWSE, LOG_BROWSE_DESCRIPTION, LOG_BROWSE_REQUEST_CONTINUATION_POINT, LOG_BROWSE_RESULT, LOG_BROWSE_RESPONSE_REFERENCES,
                           LOG_BROWSE_DIAGNOSTIC_INFO};
}

# Port-based detection
const ports = { 4840/tcp };
redef likely_server_ports += { ports };

event zeek_init() &priority=5
   {
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG,                           [$columns=OPCUA_Binary::Info,                  $path="opcua-binary"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_STATUS_CODE,               [$columns=OPCUA_Binary::StatusCodeDetail,      $path="opcua-binary-status-code-detail"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_DIAG_INFO,                 [$columns=OPCUA_Binary::DiagnosticInfoDetail,  $path="opcua-binary-diag-info-detail"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_OPENSECURE_CHANNEL,        [$columns=OPCUA_Binary::OpenSecureChannel,     $path="opcua-binary-opensecure-channel"]);

   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_GET_ENDPOINTS,             [$columns=OPCUA_Binary::GetEndpoints,          $path="opcua-binary-get-endpoints"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_GET_ENDPOINTS_DISCOVERY,   [$columns=OPCUA_Binary::GetEndpointsDiscovery, $path="opcua-binary-get-endpoints-discovery"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_GET_ENDPOINTS_USER_TOKEN,  [$columns=OPCUA_Binary::GetEndpointsUserToken, $path="opcua-binary-get-endpoints-user-token"]);

   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_CREATE_SESSION,             [$columns=OPCUA_Binary::CreateSession,          $path="opcua-binary-create-session"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_CREATE_SESSION_DISCOVERY,   [$columns=OPCUA_Binary::CreateSessionDiscovery, $path="opcua-binary-create-session-discovery"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_CREATE_SESSION_ENDPOINTS,   [$columns=OPCUA_Binary::CreateSessionEndpoints, $path="opcua-binary-create-session-endpoints"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_CREATE_SESSION_USER_TOKEN,  [$columns=OPCUA_Binary::CreateSessionUserToken, $path="opcua-binary-create-session-user-token"]);

   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_BROWSE,                     [$columns=OPCUA_Binary::Browse,                  $path="opcua-binary-browse"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_BROWSE_DESCRIPTION,  [$columns=OPCUA_Binary::BrowseDescription, $path="opcua-binary-browse-description"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_BROWSE_REQUEST_CONTINUATION_POINT, [$columns=OPCUA_Binary::BrowseRequestContinuationPoint, $path="opcua-binary-browse-request-continuation-point"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_BROWSE_RESULT,  [$columns=OPCUA_Binary::BrowseResult, $path="opcua-binary-browse-result"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_BROWSE_RESPONSE_REFERENCES, [$columns=OPCUA_Binary::BrowseReference,         $path="opcua-binary-browse-response-references"]);
   Log::create_stream(ICSNPP_OPCUA_Binary::LOG_BROWSE_DIAGNOSTIC_INFO,       [$columns=OPCUA_Binary::BrowseDiagnosticInfo,     $path="opcua-binary-browse-diagnostic-info"]);

   Analyzer::register_for_ports(Analyzer::ANALYZER_ICSNPP_OPCUA_BINARY, ports);
   }

function set_service(c: connection, service: string) {
  # Ensure that conn.log:service is set if it has not already been
  if ((!c?$service) || (|c$service| == 0))
    add c$service[service];
}

event opcua_binary_event(c: connection, info: OPCUA_Binary::Info)
   {
       set_service(c, "opcua-binary");
       info$ts  = network_time();
       info$uid = c$uid;
       info$id  = c$id;
       Log::write(ICSNPP_OPCUA_Binary::LOG, info);
    }

event opcua_binary_status_code_event(c: connection, status: OPCUA_Binary::StatusCodeDetail)
   {
       set_service(c, "opcua-binary");
       status$ts  = network_time();
       status$uid = c$uid;
       status$id  = c$id;
       Log::write(ICSNPP_OPCUA_Binary::LOG_STATUS_CODE, status);

    }

event opcua_binary_diag_info_event(c: connection, diag_info: OPCUA_Binary::DiagnosticInfoDetail)
   {
       set_service(c, "opcua-binary");
       diag_info$ts  = network_time();
       diag_info$uid = c$uid;
       diag_info$id  = c$id;
       Log::write(ICSNPP_OPCUA_Binary::LOG_DIAG_INFO, diag_info);

    }

event opcua_binary_opensecure_channel_event(c: connection, opensecure_channel: OPCUA_Binary::OpenSecureChannel)
   {
       set_service(c, "opcua-binary");
       opensecure_channel$ts  = network_time();
       opensecure_channel$uid = c$uid;
       opensecure_channel$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_OPENSECURE_CHANNEL, opensecure_channel);

    }

event opcua_binary_get_endpoints_event(c: connection, get_endpoints: OPCUA_Binary::GetEndpoints)
   {
       set_service(c, "opcua-binary");
       get_endpoints$ts  = network_time();
       get_endpoints$uid = c$uid;
       get_endpoints$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_GET_ENDPOINTS, get_endpoints);

    }

event opcua_binary_get_endpoints_discovery_event(c: connection, get_endpoints_discovery: OPCUA_Binary::GetEndpointsDiscovery)
   {
       set_service(c, "opcua-binary");
       get_endpoints_discovery$ts  = network_time();
       get_endpoints_discovery$uid = c$uid;
       get_endpoints_discovery$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_GET_ENDPOINTS_DISCOVERY, get_endpoints_discovery);

    }

event opcua_binary_get_endpoints_user_token_event(c: connection, get_endpoints_user_token: OPCUA_Binary::GetEndpointsUserToken)
   {
       set_service(c, "opcua-binary");
       get_endpoints_user_token$ts  = network_time();
       get_endpoints_user_token$uid = c$uid;
       get_endpoints_user_token$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_GET_ENDPOINTS_USER_TOKEN, get_endpoints_user_token);

    }

event opcua_binary_create_session_event(c: connection, create_session: OPCUA_Binary::CreateSession)
   {
       set_service(c, "opcua-binary");
       create_session$ts  = network_time();
       create_session$uid = c$uid;
       create_session$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_CREATE_SESSION, create_session);
   }

event opcua_binary_create_session_discovery_event(c: connection, create_session_discovery: OPCUA_Binary::CreateSessionDiscovery)
   {
       set_service(c, "opcua-binary");
       create_session_discovery$ts  = network_time();
       create_session_discovery$uid = c$uid;
       create_session_discovery$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_CREATE_SESSION_DISCOVERY, create_session_discovery);
   }


event opcua_binary_create_session_endpoints_event(c: connection, create_session_endpoints: OPCUA_Binary::CreateSessionEndpoints)
   {
       set_service(c, "opcua-binary");
       create_session_endpoints$ts  = network_time();
       create_session_endpoints$uid = c$uid;
       create_session_endpoints$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_CREATE_SESSION_ENDPOINTS, create_session_endpoints);
   }

event opcua_binary_create_session_user_token_event(c: connection, create_session_user_token: OPCUA_Binary::CreateSessionUserToken)
   {
       set_service(c, "opcua-binary");
       create_session_user_token$ts  = network_time();
       create_session_user_token$uid = c$uid;
       create_session_user_token$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_CREATE_SESSION_USER_TOKEN, create_session_user_token);
   }

event opcua_binary_browse_event(c: connection, browse_event: OPCUA_Binary::Browse)
   {
       set_service(c, "opcua-binary");
       browse_event$ts  = network_time();
       browse_event$uid = c$uid;
       browse_event$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_BROWSE, browse_event);
   }

event opcua_binary_browse_description_event(c: connection, browse_description_event: OPCUA_Binary::BrowseDescription)
   {
       set_service(c, "opcua-binary");
       browse_description_event$ts  = network_time();
       browse_description_event$uid = c$uid;
       browse_description_event$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_BROWSE_DESCRIPTION, browse_description_event);
   }

event opcua_binary_browse_request_continuation_point_event(c: connection, browse_request_continuation_point: OPCUA_Binary::BrowseRequestContinuationPoint)
    {
       set_service(c, "opcua-binary");
       browse_request_continuation_point$ts  = network_time();
       browse_request_continuation_point$uid = c$uid;
       browse_request_continuation_point$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_BROWSE_REQUEST_CONTINUATION_POINT, browse_request_continuation_point);
    }

event opcua_binary_browse_result_event(c: connection, browse_result_event: OPCUA_Binary::BrowseResult)
    {
       set_service(c, "opcua-binary");
       browse_result_event$ts  = network_time();
       browse_result_event$uid = c$uid;
       browse_result_event$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_BROWSE_RESULT, browse_result_event);
   }


event opcua_binary_browse_reference_event(c: connection, browse_reference_event: OPCUA_Binary::BrowseReference)
   {
       set_service(c, "opcua-binary");
       browse_reference_event$ts  = network_time();
       browse_reference_event$uid = c$uid;
       browse_reference_event$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_BROWSE_RESPONSE_REFERENCES, browse_reference_event);
   }

event opcua_binary_browse_diagnostic_info_event(c: connection, browse_diagnostic_info: OPCUA_Binary::BrowseDiagnosticInfo)
    {
       set_service(c, "opcua-binary");
       browse_diagnostic_info$ts  = network_time();
       browse_diagnostic_info$uid = c$uid;
       browse_diagnostic_info$id  = c$id;

       Log::write(ICSNPP_OPCUA_Binary::LOG_BROWSE_DIAGNOSTIC_INFO, browse_diagnostic_info);
    }
