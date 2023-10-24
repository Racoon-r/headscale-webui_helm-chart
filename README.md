# Headscale-webui Chart

This Helm Chart is for the Headscale-WebUI.

Headscale must be installed, and the config file of Headscale must be given to Helm.

To install it :
`helm install headscale-webui -f values.yaml --set-file configHeadscale="./config.yaml" . -n headscale-webui`

@racoon
