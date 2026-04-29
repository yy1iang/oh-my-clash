# OH-MY-CLASH

> Customized rules and configurations for Clash.
>
> **Author:** Yanyang Liang, tonyleelyy
>
> **Updated:** Apr 29, 2026

## Option 1: YAML-only Configuration

Just import YAML config to your Clash client.

### Usage

- [`config/config_regn_groups.yaml`](./config/config.yaml): A one-step universal configuration template for [mihomo](https://github.com/metacubex/mihomo) kernel, handling everything from provider node fetching to traffic control. Nodes were grouped and distributed by regions.
- [`config/config_func_groups.yaml`](./config/config_func_groups.yaml): A fine-grained configuration with **labeled proxy groups**, providing dedicated select/url-test/fallback proxy strategies per group, covering a wide range of services (Spotify, Netflix, etc.).
- [`rulesets/`](./rulesets/): A collection of curated rulesets from various providers alongside custom rules.

### Default Settings

- **Auto-update:** Nodes are fetched every **24 hours**.
- **Health Check:** Nodes undergo a delay test every **5 minutes**.
- **Grouping:** Proxies are automatically grouped by region.
- **Rule Provider:** Powered by [MetaCubeX](https://github.com/MetaCubeX/meta-rules-dat/tree/meta).

---

## Option 2: Conversion-Based Configuration

Easily convert a subscription link into a configuration file using a specified template (or the default one).

### 1. Prerequisites

The conversion depends on [`subconverter`](https://github.com/tindy2013/subconverter). You need to have it running locally:

```bash
# Download the archive
wget https://github.com/tindy2013/subconverter/releases/download/v0.9.0/subconverter_linux64.tar.gz

# Extract and run
tar -zxf subconverter_linux64.tar.gz
cd subconverter
./subconverter
```

Once running, `subconverter` will listen on port `25500` by default.

### 2. Usage

Use the [`bin/url2yaml.sh`](./bin/url2yaml.sh) script to automate the conversion process:

```bash
./bin/url2yaml.sh -i <link> -t <target> [options]

Options:
  -i  (Required) Subscription link or subconverter URL.
  -t  (Required) Target format (e.g., clash, surge, quanx).
  -c  External configuration file path or URL.
  -o  Output file path. If omitted, the request URL will be printed without fetching.
```

### Examples

**Fetch and save configuration:**
```bash
./bin/url2yaml.sh \
    -i "https://your-link" \
    -t clash \
    -c "https://raw.githubusercontent.com/config.ini" \
    -o config.yaml
```

**Generate URL only:**
```bash
./bin/url2yaml.sh -i "https://your-link" -t clash
```


