# OH MY CLASH

> Customized rules and univeral YAML config for Clash.  
> 
> Y.Y. Liang,  
> Apr 09, 2026


## Scturture

- [`config/config.yaml`](./config/config.yaml): A one-setp universal config template for [mihomo](https://github.com/metacubex/mihomo) kernel, from fetching nodes from provider to traffic controls.
- [`rulesets/`](./rulesets/): Combining rulesets picked from provider and customized.


## Default Settings

- Auto-update: Nodes will be fetched from providers in every **24 hours**. Each node will have a delay test in every **5 minutes**.
- Nodes from providers will be grouped by regions.
- Rules provider: [MetaCubeX](https://github.com/MetaCubeX/meta-rules-dat/tree/meta).


