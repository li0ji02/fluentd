FROM ubuntu:15.10

# Ensure there are enough file descriptors for running Fluentd.
RUN ulimit -n 65536

# Disable prompts from apt.
ENV DEBIAN_FRONTEND noninteractive

# Install prerequisites.
RUN apt-get update && \
    apt-get install -y -q curl make g++ sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Fluentd.
RUN /usr/bin/curl -L https://td-toolbelt.herokuapp.com/sh/install-ubuntu-trusty-td-agent2.sh | sh

# Change the default user and group to root.
# Needed to allow access to /var/log/docker/... files.
RUN sed -i -e "s/USER=td-agent/USER=root/" -e "s/GROUP=td-agent/GROUP=root/" /etc/init.d/td-agent

# Install Fluentd plug-ins.
RUN td-agent-gem install fluent-plugin-kubernetes_metadata_filter fluent-plugin-elasticsearch fluent-plugin-systemd

COPY td-agent.conf /etc/td-agent/td-agent.conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
