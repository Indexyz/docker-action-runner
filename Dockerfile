FROM alpine:3.11

# Install .NET Core
ENV DOTNET_VERSION 2.1.17
ENV RUNNER_VERSION="2.168.0"

RUN wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && dotnet_sha512='11b0cdb54b71ca07ade783a03dd8ca9b415ef351a6c8aa3d7c56af01af5dc2965f5cdb18d2184f65348ff1f69d51b69ff780200a13b79dc3a50674e1dff875e2' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -C /usr/share/dotnet -xzf dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && rm dotnet.tar.gz \
    && apk add --no-cache \
        docker \
        supervisor \
        curl \
        bash \
    && curl -sL https://github.com/docker/docker/raw/master/hack/dind > /usr/local/bin/dind \
    && chmod +x /usr/local/bin/dind \
    && mkdir /runner \
    && cd /runner \
    && wget https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm -f ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && mkdir _work

COPY config/supervisord.conf /etc/supervisord.conf
COPY config/supervisor /etc/supervisor
COPY config/entrypoint.sh /entrypoint.sh

VOLUME /var/lib/docker
VOLUME /runner/_work

CMD /entrypoint.sh
