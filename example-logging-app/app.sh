#!/bin/bash

# Log messages at all levels on the local0 facility.
logger -p local0.emerg "This is an emergency message"
logger -p local0.alert "This is an alert message"
logger -p local0.crit "This is a critical message"
logger -p local0.err "This is an error message"
logger -p local0.warning "This is a warning message"
logger -p local0.notice "This is a notice message"
logger -p local0.info "This is an informational message"
logger -p local0.debug "This is a debug message"
