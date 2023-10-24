# Headscale-webui Chart

This Helm Chart is for the Headscale-WebUI.

Headscale must be installed, and the config file of Headscale must be given to Helm.

To install it :
`kubectl install headscale-webui -f values.yaml --set-file="./config.yaml" . -n headscale-webui`

@racoon
