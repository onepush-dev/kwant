# kwant on Railway: the official release image (ghcr.io/alexsergivan/kwnt:0.7.6, AGPL-3.0),
# binary unmodified, plus a small start script:
#   - Railway mounts volumes root-owned, so it hands /data to the image's kwnt user (uid 10001)
#     and drops to it;
#   - keeps CLI sign-ins (~/.claude, ~/.codex, ~/.grok) on the same volume (HOME=/data/.home),
#     because a Railway service has one volume;
#   - listens on $PORT (8080, Railway's healthcheck/domain port) instead of 8799;
#   - sets KWNT_ALLOWED_ORIGINS to the Railway public domain when it is not set.
# Sign in with KWNT_API_TOKEN (generated per deploy by the template).
FROM ghcr.io/alexsergivan/kwnt:0.7.6@sha256:cbb43195fd71d80bd224f3e0567fcd741b8da4463547cbbe5a2d9ef212366900
USER root
COPY railway/start.sh /usr/local/bin/kwnt-railway-start
RUN chmod 755 /usr/local/bin/kwnt-railway-start
ENV KWNT_HOST=0.0.0.0 \
    PORT=8080 \
    KWNT_PORT=8080 \
    KWNT_DATA_DIR=/data \
    KWNT_LAYA_MANAGED=0 \
    KWNT_IN_DOCKER=1
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/kwnt-railway-start"]
